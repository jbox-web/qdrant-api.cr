# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Présentation

`qdrant-api` est un client REST Qdrant bas niveau et entièrement typé pour Crystal
(module `Qdrant::Api`, org `jbox-web`). C'est la couche de transport fine ; le wrapper
idiomatique orienté RAG est le shard séparé `qdrant-client.cr`.

**Tout le shard sous `src/` ainsi que les specs générées sous `spec/api` et
`spec/models` sont GÉNÉRÉS — ne pas les éditer à la main.** Les correctifs doivent aller
dans les templates du générateur en amont, pas ici. Le code généré est commité dans le dépôt.

## Commandes

L'outillage est [mise](https://mise.jdx.dev) (pas de Makefile). Les tâches sont définies
dans `mise.toml` :

```sh
mise run build        # régénère depuis le spec épinglé + formate (generate → format)
mise run generate     # génère seulement (efface src, spec/api, spec/models, spec/spec_helper.cr)
mise run format       # crystal tool format src spec
mise run dev:deps     # shards install
mise run dev:spec     # lance la suite de specs (crystal spec)
mise run dev:docs     # crystal docs → ./docs
```

Lancer une seule spec : `crystal spec spec/smoke_spec.cr` (ou `crystal spec chemin:LIGNE`).
Lint : `bin/ameba`.

## Workflow de régénération (important)

Le générateur est le générateur Crystal idiomatique écrit par Nicolas, désormais **upstream** :
[openapi-generator#24070](https://github.com/OpenAPITools/openapi-generator/pull/24070) et
[#24221](https://github.com/OpenAPITools/openapi-generator/pull/24221) sont fusionnées et
publiées dans openapi-generator **7.24.0**.

- **En local**, le générateur vient de Homebrew (`brew install openapi-generator`) — la tâche
  `generate` appelle le binaire `openapi-generator` du PATH. **En CI**,
  `.github/workflows/regenerate.yml` télécharge le jar publié depuis Maven Central et pointe
  `OPENAPI_GENERATOR_CMD` dessus. Plus aucun jar n'est construit ni stocké dans le dépôt.
- Les deux versions épinglées sont dans `mise.toml` : `OPENAPI_GENERATOR_VERSION` (générateur)
  et `QDRANT_VERSION` (spec Qdrant, commité sous `versions/qdrant-rest.<version>.yml`).
  La tâche `generate` compare la version du générateur réellement invoqué au pin et **échoue**
  en cas d'écart, pour qu'un `brew upgrade` ne produise pas silencieusement un code différent
  de celui de la CI.
- **Ne PAS construire le générateur soi-même** (`./mvnw`). Une montée de version se fait en
  bumpant `OPENAPI_GENERATOR_VERSION` puis `mise run build` et `crystal spec`. Si Nicolas dit
  avoir « mis à jour côté Java » sur une branche non publiée, lui demander comment exposer ce
  build plutôt que de le compiler.

## Versioning

Le shard n'est **jamais édité à la main** : il est une pure fonction du spec Qdrant et du
générateur. La version est du **SemVer simple `X.Y.Z`**, sans métadonnée de build.

- **Changement de version Qdrant → bump mineur** (`0.1.0` → `0.2.0`).
- **Changement générateur seul** (même Qdrant, nouveau jar → code différent) → **bump patch**
  (`0.2.0` → `0.2.1`).
- **Aucun changement** → pas de release.

La version Qdrant correspondante est enregistrée à deux endroits : le corps de la GitHub
release, et la constante **`Qdrant::Api::QDRANT_VERSION`** émise dans le code généré
(`src/qdrant-api/qdrant_version.cr`, écrit par la tâche `generate` — le générateur n'a aucune
notion de la release Qdrant amont).

### Pourquoi pas `X.Y.Z+qdrant.<ver>`

Le schéma initial encodait la version Qdrant en métadonnée de build SemVer. Il a dû être
abandonné : **`shards` ne sait pas la consommer**, ce qui rendait le shard impossible à
installer par quelque moyen que ce soit.

- `VERSION_TAG = /^v(\d+[-.][-.a-zA-Z\d]+)$/` (shards `src/config.cr`) n'accepte pas `+` dans
  la classe de caractères. Les tags `v0.2.0+qdrant.1.18.2` & co. étaient donc invisibles pour
  `versions_from_tags`, et **aucune contrainte `version:` ne pouvait résoudre**.
- En résolution par `tag:`, `commit:` ou `branch:`, shards fabrique
  `#{spec.version}+git.commit.#{sha}` — soit une chaîne à deux `+` que `VERSION_AT_GIT_COMMIT`
  ne sait pas reparser.

Ne pas réintroduire la métadonnée tant que shards n'aura pas été corrigé en amont.

Tout est **automatisé, sans intervention**, dans `.github/workflows/regenerate.yml` (hebdo) :
il détecte la dernière release `qdrant/qdrant`, télécharge son spec
(`raw.githubusercontent.com/qdrant/qdrant/v<ver>/docs/redoc/master/openapi.json`), bumpe
`QDRANT_VERSION`, régénère, lance les specs (**gate** : rien n'est publié si elles échouent),
bumpe `shard.yml`, commit, tag `v<version>` et crée la GitHub release. `shard.yml` est la
source de vérité de la dernière version publiée (`QDRANT_VERSION` celle du Qdrant en cours).

### Fichiers maintenus à la main

`.openapi-generator-ignore` protège les fichiers que le générateur ne peut pas produire
correctement : `README.md`, `LICENSE`, `shard.yml` (le générateur ne peut pas fixer la
contrainte de version `crystal:`), `mise.toml`, `.github/**`, `.gitignore`. La tâche
`generate` efface volontairement uniquement `src spec/api spec/models spec/spec_helper.cr`
pour que les specs écrites à la main comme `spec/smoke_spec.cr` survivent à la régénération.

## Architecture

Le client est une **façade par instance** (pas de singleton global) au-dessus d'une unique
méthode de requête générique. Comprendre ces quatre pièces explique tout le shard :

- **`Client` (`src/qdrant-api/client.cr`)** — `Client.new(host:, token:, scheme:)` construit
  une `Configuration` + une `Connection`. Expose des **sous-clients** namespacés, mémoïsés
  paresseusement, qui reflètent la surface de l'API :
  `client.collections.points.search(...)`, `client.collections.index`, `client.cluster.peer`,
  `client.aliases`, etc. Chaque sous-client encapsule simplement la `Connection` partagée.

- **`Connection#request` (`src/qdrant-api/connection.cr`)** — l'unique chemin de code par
  lequel passent toutes les opérations. Générique sur le type de réponse `T` :
  `request(T.class, *, method:, path:, body:, query:, form:, header:, accept:, auth:, raw:)`.
  Il sérialise `body` en JSON, applique l'auth, exécute via `crest`, et en cas de 2xx décode
  le corps en `T` (spécialisé par macro : `Nil` → nil, `String` → brut ou JSON dé-quoté,
  sinon `T.from_json`). Un non-2xx lève `ApiError`.

- **Fichiers d'opérations API (`src/qdrant-api/api/*.cr`)** — une méthode fine par endpoint
  qui appelle `@conn.request(TypeDeReponse, method:, path:, ...)`. C'est là que vivent les
  chemins, verbes HTTP et schémas d'auth par endpoint.

- **Modèles (`src/qdrant-api/models/*.cr`, ~320 fichiers)** — une struct/classe par schéma
  OpenAPI, chacune incluant `Serializable` (`to_h`/`to_json`/`to_body`) et, quand le schéma
  a des contraintes, `Validation`. Les enums nommés sont émis comme `alias X = String` plus
  une règle `validates(..., enum: [...])` ; les unions `anyOf` de primitifs et les enums
  inline utilisent la même approche à base de String, donc tout (dé)sérialise de façon
  transparente via JSON.

Chaque appel retourne une **`Response(T)`** exposant `value`, `status`, `headers`, `success?`.

`Validation.validates(name, Type, nilable, **rules)` est une macro
(`src/qdrant-api/validation.cr`) qui génère un setter validant par propriété contrainte ;
règles supportées : `enum`, `min/max_length`, `minimum`/`maximum` (avec variantes
exclusives), `pattern`, `min/max_items`.

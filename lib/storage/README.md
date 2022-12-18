#DATA SCHEMA

- files

  - hash - primary key
  - path - string

- packages

  - id - primary key
  - name - primary unique
  - owner - userId

- versions

  - id - primary key
  - packageId
  - minor - number
  - major - number
  - path - number
  - postfix - string

- mode (dev, prod, test)

  - id
  - versionId
  - title

- engine (line a constant do not has table)

  - id
  - title

- package_mode_engine_file

  - package_id
  - mode_id
  - engine_id
  - file_id

- owners
  - id
  - email

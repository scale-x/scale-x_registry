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

- package_mode_engine_file

- authors
  - uuid
  - email

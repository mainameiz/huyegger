
This project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Prerelease versions

According to https://semver.org/#spec-item-4 0.x versions should not be considered as stable, anything can change at any time.

## [Unreleased]

- Add `timestamp` field to all messages.

## 0.4.3 - 2018-05-28

- Fixed double message keys:

  ```ruby
    # before fix
    logger.info(message: 'test') # => "{ ...,"message":"Empty message","message":"test"}"

    # after fix
    logger.info(message: 'test') # => "{ ...,"message":"test"}"
  ```

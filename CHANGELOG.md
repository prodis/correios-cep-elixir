# Changelog
All notable changes to this project will be documented in this file.

## [Unreleased]
## Changed
- Update HTTPoison to 1.17.0 (hackeny 1.16.0)

## Deprecated
- The field `zipcode` in `Correios.CEP.Address`. Use the field `postal_code` instead.

## Removed
- Support for OTP 20.

## [0.5.1] - 2020-06-09
### Added
- The field `postal_code` in `Correios.CEP.Address` with the same value of `zipcode` field, that
will be deprecated in the next version. Part of the [Issue #17](https://github.com/prodis/correios-cep-elixir/issues/17).

## [0.5.0] - 2020-05-24
### Added
- Support for proxy configuration. [Issue #7](https://github.com/prodis/correios-cep-elixir/issues/7)

### Changed
- Update dependencies.

## [0.4.0] - 2020-04-19
### Added
- Correios API full URL in options.
- Missing code documentation and typespecs.
- Makefile.

### Changed
- General update and refactoring.

### Fixed
- Remove dependency from config/config.exs. [Issue #15](https://github.com/prodis/correios-cep-elixir/issues/15)

## [0.3.0] - 2010-01-01
### Added
- Validate zip code. [Issue #11](https://github.com/prodis/correios-cep-elixir/issues/11)
- Typespecs and Dialyzer. [Issue #1](https://github.com/prodis/correios-cep-elixir/issues/1)

## [0.2.0] - 2018-11-26
### Added
- Timeout options. [Issue #6](https://github.com/prodis/correios-cep-elixir/issues/6)

## [0.1.0] - 2018-11-12
### Added
- Initial release.

[Unreleased]: https://github.com/prodis/correios-cep-elixir/compare/0.5.1...master
[0.5.1]: https://github.com/prodis/correios-cep-elixir/compare/0.5.0...0.5.1
[0.5.0]: https://github.com/prodis/correios-cep-elixir/compare/0.4.0...0.5.0
[0.4.0]: https://github.com/prodis/correios-cep-elixir/compare/v0.3.0...0.4.0
[0.3.0]: https://github.com/prodis/correios-cep-elixir/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/prodis/correios-cep-elixir/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/prodis/correios-cep-elixir/compare/69f7fa4...v0.1.0

The format of this file is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and
this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

# Change Log

## Unreleased


## v0.10.0 - 2014-12-27

### Changed

- Rails 4.2.0 compatibility
- Confirmations controller now returns 400 or 404 HTTP status codes when
  failing to find a valid resource for the token (or missing token).
- The `janus` instance is now accessible in Janus::TestHelper.

### Fixed

- Login failure when password wasn't set (invalid encrypted password).


## v0.9.1 - 2014-08-27

### Added

- `Janus::SessionsController#valid_host?(host)` to interrupt a blind redirection
  when `params[:return_to]` is the current host. See b120010.

### Fixed

- Compatibility with the latest Rails 4.0 and 4.1 releases that fixed a
  bug with strong parameters. See 5b5a7e7

Compare: https://github.com/ysbaddaden/janus/compare/v0.9.0...v0.9.1

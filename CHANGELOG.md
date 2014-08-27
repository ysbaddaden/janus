v0.9.1

- Fixed compatibility with the latest Rails 4.0 and 4.1 releases that fixed a
  bug with strong parameters. See 5b5a7e7
- `Janus::SessionsController#valid_host?(host)` to interrupt a blind redirection
  when `params[:return_to]` is the current host. See b120010.

Compare: https://github.com/ysbaddaden/janus/compare/v0.9.0...v0.9.1

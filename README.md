# vim-org

A lightweight Vim plugin inspired by vimwiki for note-taking and organizing with syntax highlighting, providing simple navigation between linked files within any directory which path contains `/org/` folder. 

## Features

- **Simple Link Navigation**: Easily navigate between files using `[[file/path]]` syntax
  - Press `Enter` to follow a link
  - Press `Backspace` to go back
  - Files are automatically saved when navigating
  - Directory links (e.g., `[[folder/folder]]`) automatically resolve to `folder/folder/index`

- **Automatic Org Filetype Detection**: Files without extensions in directories containing "org" are automatically detected as Org files

- **Clean Visualization**: Links are displayed with concealed brackets and underlined for better readability

- **Rich Syntax Highlighting**: Support for various heading styles:

  ```
  ===============
  = SUPER TITLE =
  ===============

  = PRIMARY TITLE =
  == SECONDARY TITLE (SUBTITLE) ==
  === TERCIARY TITLE (SUBSUBTITLE) ===

  # PRIMARY ITEM
  ## SECONDARY ITEM (SUBITEM)
  ### TERCIARY ITEM (SUBSUBITEM)

  ===========================
  % SUPER ALTERNATIVE TITLE %
  ===========================
  
  % ALTERNATIVE TITLE %
  %% ALTERNATIVE SUBTITLE %%
  ```

## Installation

### Using Vim 8+ native package manager

```bash
mkdir -p ~/.vim/pack/plugins/start
git clone https://github.com/optimista/vim-org.git ~/.vim/pack/plugins/start/vim-org
```

### Using vim-plug

Add to your `.vimrc`:

```vim
Plug 'optimista/vim-org'
```

Then run `:PlugInstall`

### Using Vundle

Add to your `.vimrc`:

```vim
Plugin 'optimista/vim-org'
```

Then run `:PluginInstall`

## Usage

1. Create files without extensions in a directory containing "org" in its path
2. Add wiki-style links using the `[[path/to/file]]` syntax 
3. Navigate to links by positioning your cursor on a link and pressing `Enter`
4. Return to the previous file by pressing `Backspace`

### Syntax Examples

```
= Main Topic =

This is content with a [[link/to/another/file]].

== Subtopic ==

More content with a [[link/to/folder]] that will open folder/index.

=== Sub-subtopic ===

# List Item 1
## Sub-item
### Sub-sub-item

=================
% Alternative Section %
=================

This section is at the same level as "Main Topic" but represents 
a different category or meta information.
```

## Configuration

By default, the plugin has reasonable settings that work out of the box. However, you can customize:

- Link concealment behavior by changing Vim's conceallevel setting in your vimrc
- Highlighting colors by modifying your colorscheme

## License

MIT

## Credits

Inspired by VimWiki's link navigation system, but simplified to focus solely on link functionality.

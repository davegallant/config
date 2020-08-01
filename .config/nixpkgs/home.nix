{ pkgs, ... }:

{

  home = {
    sessionVariables = {
      EDITOR = "vim";
    };
    packages = with pkgs; [
      audio-recorder
      awscli2
      bandwhich
      bat
      bind
      chromium
      clipmenu
      curl
      direnv
      dunst
      element-desktop
      exa
      fd
      firefox
      fzf
      gimp
      git
      glibcLocales
      gnumake
      go
      google-cloud-sdk
      gopass
      gradle
      groovy
      hadolint
      htop
      imagemagick
      jdk
      jetbrains.idea-community
      jq
      kubectl
      libreoffice
      maven
      nixpkgs-fmt
      nmap
      nodejs-14_x
      openvpn
      packer
      pinentry-curses
      postman
      python38
      ripgrep
      rtv
      rustup
      shellcheck
      shfmt
      signal-desktop
      slack
      spotify
      starship
      terraform
      terraform-lsp
      tflint
      tmux
      tree
      unzip
      vlc
      vscode
      xclip
      xdg_utils
      youtube-dl
      zathura
      zip

      ## linux
      pavucontrol
      polybar
      ssm-session-manager-plugin

      # python
      python38Packages.ipython
      python38Packages.pip
      python38Packages.setuptools
      python38Packages.virtualenv
      black

      # overlays
      rfd

      # fonts
      dejavu_fonts
      fira-code
      fira-code-symbols
      fira-mono
      font-awesome
      google-fonts
      noto-fonts
      noto-fonts-emoji
      noto-fonts-extra
    ];
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 3600;
      defaultCacheTtlSsh = 3600;
      enableSshSupport = true;
      extraConfig = ''
        pinentry-program ${pkgs.pinentry-curses}/bin/pinentry
      '';
    };
  };


  fonts.fontconfig.enable = true;

  programs = {

    home-manager.enable = true;

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      history.size = 1000000;

      localVariables = {
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=#838383,underline";
        ZSH_DISABLE_COMPFIX = "true";
        DISABLE_UNTRACKED_FILES_DIRTY="true";
        CASE_SENSITIVE="true";
      };

      initExtra = ''
        export GOPATH=~/go
        export GPG_TTY=$(tty)
        export PATH=$PATH:~/.local/bin
        export PATH=$PATH:~/go/bin
        export PATH=$PATH:~/.cargo/bin
        export PATH=$PATH:~/.npm-packages/bin

        export LANG=en_US.UTF-8

        eval "$(direnv hook zsh)"
        eval "$(_RFD_COMPLETE=source_zsh rfd)"
        eval "$(starship init zsh)"

        setopt noincappendhistory
      '';

      shellAliases = {
        ls = "exa -la --git";
        ".." = "cd ..";
        config = "/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
        grep = "grep --color=auto --line-buffered";
      };

      "oh-my-zsh" = {
        enable = true;
        plugins = [
          "fzf"
          "git"
          "last-working-dir"
        ];
      };

      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
      ];
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      extraConfig = ''
        call plug#begin('~/.vim/plugged')
        Plug 'LnL7/vim-nix'
        Plug 'ap/vim-css-color'
        Plug 'fatih/vim-go'
        Plug 'hashivim/vim-terraform'
        Plug 'itchyny/lightline.vim'
        Plug 'junegunn/fzf'
        Plug 'junegunn/fzf.vim'
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
        Plug 'rust-lang/rust.vim'
        Plug 'scrooloose/nerdtree'
        Plug 'tpope/vim-commentary'
        Plug 'tpope/vim-fugitive'
        Plug 'tpope/vim-surround'
        Plug 'vifm/vifm.vim'
        Plug 'vim-syntastic/syntastic'
        Plug 'yuki-ycino/fzf-preview.vim'
        call plug#end()

        set autoread
        set cursorline
        set encoding=utf-8
        set expandtab
        set foldlevel=99
        set foldmethod=indent
        set hlsearch
        set ignorecase
        set incsearch
        set laststatus=2
        set modelines=0
        set mouse=a
        set nocompatible
        set noswapfile
        set number
        set pastetoggle=<F3>
        set ruler
        set shiftwidth=2
        set showcmd
        set showmode
        set smartcase
        set t_Co=256
        set tabstop=2
        set wildmenu

        " Remember line number
        if has("autocmd")
          au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
        endif

        " Search down into subfolders
        " Provides tab-completion for all file-related tasks
        set path+=**

        filetype plugin indent on

        " Enable folding with the spacebar
        nnoremap <space> za

        " replace visually selected
        vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>

        " Custom Commands
        command JsonFormat execute "::%!jq '.'"

        " Shortcuts
        map <Leader>r :FzfPreviewProjectCommandGrep<CR>
        map <Leader>f :FzfPreviewDirectoryFiles<CR>
        map <Leader>n :NERDTree<CR>

        noremap <Leader>y "*y
        noremap <Leader>p "*p
        noremap <Leader>Y "+y
        noremap <Leader>P "+p

        " Python indentation
        au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix

        let python_highlight_all=1

        syntax on
        colorscheme gruvbox
        " Transparency
        hi Normal guibg=NONE ctermbg=NONE

        " highlight red lines
        highlight ExtraWhitespace ctermbg=red guibg=red
        match ExtraWhitespace /\s\+$/

        " groovy syntax
        au BufNewFile,BufRead *.groovy set tabstop=2 shiftwidth=2 expandtab
        au BufNewFile,BufRead Jenkinsfile setf groovy
        au BufNewFile,BufRead Jenkinsfile set tabstop=2 shiftwidth=2 expandtab

        " vim-go
        let g:go_auto_sameids = 0
        let g:go_fmt_command = "goimports"
        let g:go_fmt_experimental = 1
        let g:go_highlight_array_whitespace_error = 1
        let g:go_highlight_build_constraints = 1
        let g:go_highlight_chan_whitespace_error = 1
        let g:go_highlight_extra_types = 1
        let g:go_highlight_fields = 1
        let g:go_highlight_format_strings = 1
        let g:go_highlight_function_calls = 1
        let g:go_highlight_function_parameters = 1
        let g:go_highlight_functions = 1
        let g:go_highlight_generate_tags = 1
        let g:go_highlight_operators = 1
        let g:go_highlight_space_tab_error = 1
        let g:go_highlight_string_spellcheck = 1
        let g:go_highlight_trailing_whitespace_error = 0
        let g:go_highlight_types = 1
        let g:go_highlight_variable_assignments = 1
        let g:go_highlight_variable_declarations = 1
        let g:go_metalinter_autosave=1
        let g:go_metalinter_autosave_enabled=['golint', 'govet']
        let g:go_rename_command = 'gopls'

        " vim-terraform
        let g:terraform_align=1
        let g:terraform_fmt_on_save=1
        let g:terraform_fold_sections=1

        " rust.vim
        let g:rustfmt_autosave = 1

        " syntastic
        set statusline+=%#warningmsg#
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*

        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 1
        let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 0
      '';
    };
  };
}

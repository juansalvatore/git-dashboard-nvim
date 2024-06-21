<div align="center">

# git-dashboard-nvim
##### Your git contributions heatmap chart inside your favorite nvim dashboard.

[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim](https://img.shields.io/badge/Neovim%200.8+-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)

<img width="831" alt="image" src="https://github.com/juansalvatore/git-dashboard-nvim/assets/11010928/85609c97-22be-4a92-8f21-568c00f1d207">
</div>


## ⇁ TOC
* [Intro](#-Intro)
* [Installation](#-Installation)
* [Getting Started](#-Getting-Started)
* [Config](#-Config)
* [Contribution](#-Contribution)
* [Social](#-Social)


## ⇁ Intro
`git-dashboard-nvim` is a modular solution to displaying your git commit contributions as an nvim heatmap dashboard.
It uses [vimdev/dashboard-nvim](https://github.com/nvimdev/dashboard-nvim) as the base for the dashboard and this plugin generates the header dynamically that we can pass to dashboard-nvim. This allows you to use your dashboard as always.
It mainly solves the issue of tracking project based progress in a visual way and making my nvim dashboard look cool while still being useful by showcasing the current git branch and project.


## ⇁ Installation
* neovim 0.8.0+ required
* install using your favorite plugin manager (i am using `Lazy` in this case)
* install using [lazy.nvim](https://github.com/folke/lazy.nvim)
  
```lua
{
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = {
      { 'juansalvatore/git-dashboard-nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
    },
    opts = function()
      local ascii_heatmap = require('git-dashboard-nvim').setup {}

      local opts = {
        theme = 'doom',
        config = {
          header = ascii_heatmap,
        },
      }

      -- extra dashboard nvim config ...

      return opts
    end,
  }
```

## ⇁ Getting Started
The dashboard by default will show a heatmap for the repo in which you are opening nvim and it will track the branch you are currently at (switching branches will change the heatmap to show commits in the respective branch).
By default it tracks all commits, but you can specify an author to just track their commits.

## ⇁ Config
This is the default config, feel free to change things around (some things like chaning months or day labels may look bad if more characters are added)
```lua
      local ascii_heatmap = require('git-dashboard-nvim').setup {
        -- author = 'Juan Salvatore',
        branch = 'main',
        gap = ' ',
        top_padding = 23,
        bottom_padding = 20,
        show_repo_name = true,
        fallback_header = '',
        author = '',
        day_label_gap = ' ',
        empty = ' ',
        empty_square = '□',
        filled_square = '■',
        title = 'repo_name',
        show_current_branch = true,
        days = { 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' },
        months = { 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' },
        use_current_branch = true,
        colors = {
          days_and_months_labels = '#7eac6f',
          empty_square_highlight = '#54734a',
          filled_square_highlight = '#AFD2A3',
          branch_highlight = '#8DC07C',
          dashboard_title = '#a3cc96',
        },
      }
```

**Config Definition**
```lua
---@class Colors
---@field days_and_months_labels string
---@field empty_square_highlight string
---@field filled_square_highlight string
---@field branch_highlight string
---@field dashboard_title string

---@class Config
---@field fallback_header string
---@field top_padding number
---@field bottom_padding number
---@field author string
---@field branch string
---@field gap string
---@field day_label_gap string
---@field empty string
---@field empty_square string
---@field filled_square string
---@field title "owner_with_repo_name" | "repo_name" | "none"
---@field show_current_branch boolean
---@field days string[]
---@field months string[]
---@field use_current_branch boolean
---@field colors Colors
```

## ⇁ Contribution
This project open source, so feel free to fork if you want very specific functionality. If you wish to
contribute start with an issue and I am totally willing for PRs, as long as your PR leaves the default look 
and functionality intact I will accept features that build on top or improve things.
I tarted using nvim around two months ago along with lua, so this is a project I mainly built for myself and to learn a bit more about lua and nvim,
but given that I think someone else may enjoy having this as their dashboard I decided to make it open source.

**Tests**
I'm using [plenary](https://github.com/nvim-lua/plenary.nvim) and for now I'm just running them using <Plug>PlenaryTestFile %

## ⇁ Social
* [Twitter](https://twitter.com/jnsalvatore)

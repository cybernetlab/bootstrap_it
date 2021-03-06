# General info

This package provides helpers for easly creating sites with [Twitter Bootstrap 3](http://getbootstrap.com) framework.

> **Warning!** This gem is in active development state. Please, don't use it in production.

# Why to use it?

At first, it simplify views writing process. You dont't need to keep in mind Bootstrap-specific markup - just write `<%= button 'text', :success %>` and thats it! At the same time, your views will looks clearly.

At second, when Bootstrap version changed and some HTML attributes needs to be updated, you don't need to search through all your views for this changes to switch your project to new version. Just select appropriate version with `gem bootstrap_it, 'x.x.x'`. In future releases, markup part of library will be separated from main code and will be versioned respectively to Twitter Bootstrap versions.

At third, you can easily extend helpers with your own. This package use [WrapIt](https://github.com/cybernetlab/wrap_it) library, see it's documentation for details.

# State

Project is in active development state now. First release version is `1.0.0` and planned at second half of February. Version `0.1.0` and all other `0.x.x` are for testing purposes.

Not implemented now: forms, inputs, thumbnails, media object, list group, panels, wells and allmost all from JavaScript section of Bootstrap documentation.

# Installation

put following line in you `Gemfile`

```ruby
gem 'bootstrap_it'
```

and run

```sh
bundle install
```

Add bootstrap_it to your `layout` file:

```html
<!DOCTYPE html>
<html>
  <head>
    ...
    <%= bootstrap_it %>
  </head>
</html>
```

# Configuration

Full Rails-style configuration is not implemented yet. So, to change config options, just put following line inside your `config/application.rb`:

```ruby
  class Application < Rails::Application
    ...
    BootstrapIt.config.assets_source = :cdn
  end
```

## Bootstrap assets

Now, you have two choises: at first, CDN source of CSS and JavaScript. And second is minified versions of assets, downloaded from official sites. Third options - compile from LESS source will be available soon. So, you can configure bootstrap_it in `application.rb` like this:

```ruby
BootstrapIt.config.assets_source = :cdn # or :precompiled for minified version
```

> Package have some other options, thats are not implemented yet. Look into `lib/bootstrap_it/config.rb` for details.

# Usage

## Sample application

You can explore [sample application](https://github.com/cybernetlab/bootstrap_it_sample), especially `app/views/welcome/index.html.erb` for usage examples. This repository will be updated frequently, so keep track on it.

## Common guidelines

### Flags and enumerations arguments and options

All helpers supports Bootstrap flags and enumerations, passed as symbols. Any flag can be setted or cleared by boolean option. Enumerations can be specified in options by their names. For example, following two lines

```ruby
button 'Text', :large, :active, :success
button 'Text', size: :large, active: true, appearence: :success
```

produces same HTML:

```html
<button type="button" class="btn btn-success btn-lg active">Text</button>
```

Order of flags irrelevant, but all flags and enumerations should be **symbols**. Only supported flags allowed, so refer to [Bootstrap documentation](getbootstrap.com/css) or read corresponding section of this document for valid values. You can replace hyphens `-` to underscores `_` in class names.

### HTML attributes via options

You can specify any attribute for element just in creation options:

```ruby
button :success, 'Text', class: 'super', attr: 'value'
```

produces HTML:

```html
<button type="button" class="btn btn-success super" attr="value">Text</button>
```

In some cases, it will overrided to provide correct Bootstrap manner.

### HTML tag names

In most cases you can override default tag name via `tag` option:

```ruby
button :success, 'Text', tag: 'a', href: 'http://some.url'
```

produces HTML:

```html
<a role="button" class="btn btn-success" href="http://some.url">Text</a>
```

Note, that `role` attribute added automatically.

### Capturing tags

Not all helpers produces HTML, but it's recommended to always use capturing tags `<%= >` instead of `<% >` form.

## Components

### Grid system

Main helper is `grid`. You can add rows to it with `row` method and cells to rows with `cell` method. Rows can be nested, so cell have `row` method. Also clearfixes elements supports for rows via `clear` method.

Cells can have `extra_small`, `small`, `medium` and `large` size specification. Also supported corresponding aliases `xs`, `sm`, `md` and `lg`. You can specify size with digit at the end. For example, `col-sm-4` Bootstrap class correspond to `:sm4` or `:small4` or `:sm_4` or `:small_4` or `:col_sm_4` or `:col_small_4` argument. You can specify element offset, push and pull in same way. For example `:medium_offset_3` will produce `col-md-offset-3` class.

If no size specified, cell have `col-md-3` class by default.

You can provide text to cell by passing it as string argument.

*Example:*

```ruby
grid do |g|
  g.row do |r|
    r.cell :md4, 'col 1'
    r.cell :md4, :md_offset_4, 'col 2'
  end
  g.row do |r|
    r.cell :md6, :md_offset_3, 'col 3'
    r.clear
  end
end
```

*will produce HTML:*

```html
<div class="container">
  <div class="row">
    <div class="col-md-4">col 1</div>
    <div class="col-md-4 col-md-offset-4">col 2</div>
  </div>
  <div class="row">
    <div class="col-md-6 col-md-offset-3">col 3</div>
    <div class="clearfix"></div>
  </div>
</div>
```

### Tables

tables created by main `table` helper. You can add rows and cells as in previous chapter. Table have following flags: `striped`, `bordered`, `hover`, `condensed` and `responsive`. Rows and cells can have one value from following enum: `active`, `success`, `warning`, `danger`. Cells can be produces by `cell` or `td` method of row. To make `<th>`, use `head` or `th` methods. Cells also have size specification but not offsets and push/pull.

*Example:*

```ruby
table :condensed, :bordered do |t|
  t.row :success do |r|
    r.head 'header 1'
    r.head 'header 2'
  end
  t.row do |r|
    r.cell 'data', colspan: 2
  end
end
```

*will produce HTML:*

```html
<table class="table table-condensed table-bordered">
  <tr class="success">
    <th>header 1</th>
    <th>header 2</th>
  </tr>
  <tr>
    <td colspan="2">data</td>
  </tr>
</table>
```

### Forms

Forms are in development now.

### Buttons

Buttons created by `button` helper. Buttons supports sizes via `:large`, `:small` and `:extra_small` flags and their aliases `:lg`, `:sm` and `:xs`. You can specify one of following appearence type: `:default`, `:primary`, `:success`, `:info`, `:warning`, `:danger` and `:link`. For creating block level buttons, use `:block` flag. Also supported `:active` and `:disabled` switchers.

Icon can be added to button with `icon` option.

*Example:*

```ruby
button :danger, :large, 'alert', icon: 'home'
```

*will produce HTML:*

```html
<button type="button" class="btn btn-danger"><i class="fa fa-home"></i> alert</button>
```

### Icons

You can use icon set from bootstrap or font-awesome. To select icon set use following configuration option:

```ruby
BootstrapIt.config.font_awesome = true
```

To produce icon, use `icon` helper with icon name as argument.

*Example:*

```ruby
icon :asterisk
```

*will produce HTML:*

```html
<i class="fa fa-asterisk"></i>
```

### Button groups

To create button group use `button_group` helper. And then add buttons with `button` method. To create group of radio or checkbox behaviour buttons, use `redio` or `checkbox` methods. To create dropdown button use `dropdown` method. You can specify size for included buttons by `:large`, `:small` and `:extra_small` or `:lg`, `:sm` and `:xs` arguments. To create vertical group use `:vertical` switch. Also `:justified` switch available. 

*Example:*

```ruby
button_group do |g|
  g.button 'one'
  g.button 'two', :success
  g.dropdown 'dropdown' do |d|
    d.link_item 'link 1', '#'
    d.link_item 'link 2', '#'
  end
end

button_group do |g|
  g.radio 'radio 1', :primary
  g.radio 'radio 2', :primary
end
```

*will produce HTML:*

```html
<div class="btn-group">
  <button type="button" class="btn btn-default">one</button>
  <button type="button" class="btn btn-success">two</button>
  <div class="btn-group">
    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
      dropdown
      <span class="caret"></span>
    </button>
    <ul class="dropdown-menu" role="menu">
      <li role="presentation"><a href="#" role="menuitem" tabindex="-1">link 1</a></li>
      <li role="presentation"><a href="#" role="menuitem" tabindex="-1">link 2</a></li>
    </ul>
  </div>
</div>

<div class="btn-group" data-toggle="buttons">
  <label class="btn btn-primary">
    <input type="checkbox"></input>radio 1
  </label>
  <label class="btn btn-primary">
    <input type="checkbox"></input>radio 2
  </label>
</div>
```

### Button toolbar

Button groups can be grouped in button toolbar. Use `toolbar` or `button_toolbar` (it's alias) to make toolbars.

### Dropdown button

To make separate dropdown button use `dropdown_button` helper. You can create splitted dropdown with `:splitted` flag and dropped up buttons with `:dropup` flag.

*Example:*

```ruby
dropdown_button :danger, :splitted, 'Button' do |b|
  b.header 'Actions'
  b.link_item 'Action', '#'
  b.link_item 'Another action', '#'
  b.divider
end
```

*will produce HTML:*

```html
<div class="btn-group">
  <button type="button" class="btn btn-danger">Button</button>
  <button type="button" class="btn btn-danger dropdown-toggle" data-toggle="dropdown">
    <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" role="menu">
    <li role="presentation" class="dropdown-header">Actions</li>
    <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Action</a></li>
    <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Another action</a></li>
    <li role="presentation" class="divider"></li>
  </ul>
</div>
```

### Input groups

Input groups are in development.

### Navs

You can create nav pills or nav tabs with `nav_pills` or `pills` and `nav-tabs` or `tabs` helpers. Provide items with `link_item` method. Pills can be vertically stacked with `:stacked` flag. You can justify navs with `:justified` switch. Any item can be disabled with `:disabled` and takes active state with `:active` flags. Use `item` to create items without links and `dropdown` to make dropdown items.

*Example:*

```ruby
pills do |p|
  p.link_item :active, 'Home', '#'
  p.link_item 'Profile', '#'
  p.link_item 'Messages', '#'
end
```

*will produce HTML:*

```html
<ul class="nav nav-pills">
  <li class="active"><a href="#">Home</a></li>
  <li><a href="#">Profile</a></li>
  <li><a href="#">Messages</a></li>
</ul>
```

### Navbar

Navbar implementation is not finished yet.

### Breadcrumps

Breadcrumps available via `breadcrumb` helper.

*Example:*

```ruby
breadcrumb do |b|
  b.link_item 'Home', '#'
  b.link_item 'Library', '#'
  b.item :active, 'Data'
end
```

*will produce HTML:*

```html
<ol class="breadcrumb">
  <li><a href="#">Home</a></li>
  <li><a href="#">Library</a></li>
  <li class="active">Data</li>
</ol>
```

### Pagination and pagers

To create pagination or pager, use `pagination` and `pager` helpers. You can use `:large` and `:small` or `:lg` and `sm:` sizes for pagination. In pager, use `link_item` or `previous` and `next` methods.

*Example:*

```ruby
pagination do |p|
  p.link_item '&laquo;', '#', :disabled
  p.link_item '1', '#', :active
  p.link_item '2', '#'
  p.link_item '3', '#'
  p.link_item '&raquo;', '#'
end

pager do |p|
  p.previous '&larr; Older', '#', :disabled
  p.next 'Newer &rarr;', '#'
end
```

*will produce HTML:*

```html
<ul class="pagination">
  <li class="disabled"><a href="#">&laquo;</a></li>
  <li class="active"><a href="#">1</a></li>
  <li><a href="#">2</a></li>
  <li><a href="#">3</a></li>
  <li><a href="#">&raquo;</a></li>
</ul>

<ul class="pager">
  <li class="previous disabled"><a href="#">&larr; Older</a></li>
  <li class="next"><a href="#">Newer &rarr;</a></li>
</ul>
```

### Labels and badges

Use `label` and `badge` helpers. Labels can be `:default`, `:primary`, `:success`, `:info`, `:warning` or `:danger`.

*Example:*

```ruby
label :info, 'label text'
badge '10'
```

*will produce HTML:*

```html
<span class="label label-info">label text</span>
<span class="badge">10</span>
```


### Jumbotron

Use `jumbotron` helper. To create full-width jumbotron, place it outside other other `.container` blocks and use `full_width` flag.

*Example:*

```html
<%= jumbotron do %>
  <h1>Hello, world!</h1>
<% end %>
```

*will produce HTML:*

```html
<div class="jumbotron">
  <h1>Hello, world!</h1>
</div>
```

### Page header

Use `page_header` helper

*Example:*

```html
<%= page_header do %>
  <h1>Hello, world!</h1>
<% end %>
```

*will produce HTML:*

```html
<div class="page-header">
  <h1>Hello, world!</h1>
</div>
```

### Thumbnails

Thumbnails is not implemented yet.

### Alerts

Use `alert_box` helper. To change appearence use `appearence` enum with following values: `success`, `info`, `warning`, `danger`. To make alert dismissable, use `dismissable` flag. To make your links inside alerts well-looking, use `link` method of alert.

*Example:*

```ruby
alert_box :success, :dismissable do |a|
  a.link 'link text', 'url'
end
```

*will produce HTML:*

```html
<div class="alert alert-success alert-dismissable">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  <a href="url" class="alert-link">link text</a>
</div>
```

### Progress Bar

Use `progress_bar` or `progress` helper. To specify completed percents just pass any Numeric argument, or use `completed` option. To change appearence use `appearence` enum with following values: `success`, `info`, `warning`, `danger`. You can use `striped` flag to make bar striped and `active` flag to make bar animated. You can make more that one progress bar stacked together. To do this, use `bar` method of progress bar object to add other bars. To override `sr-only` text for bar, specify it as String argument, or use `body` or `text` option.

*Example:*

```ruby
progress_bar :striped, :success, 35, '35% total complete' do |p|
  p.bar :warning, 20, '20% files complete'
end
```

*will produce HTML:*

```html
<div class="progress progress-striped">
  <div class="progress-bar progress-bar-success" style="width: 35%" role="progressbar" aria-valuenow="35" aria-valuemin="0" aria-valuemax="100">
    <span class="sr-only">35% total complete</span>
  </div>
  <div class="progress-bar progress-bar-warning" style="width: 20%" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">
    <span class="sr-only">20% files complete</span>
  </div>
</div>
```

### Media objects

This and all other stuff are in development.

# Todo

- finish bootstrap components implementation
- documentation
- implement LESS compilation
- finish Rails config
- create Rails generators
- `simple_form` integration
- `simple-navigation` integration

# Long time plans

- integration to other ruby frameworks, such as `Sinatra`

# Changes

`0.1.2`
* switched to wrap_it 0.2.0
* code refactoring
* testing improvements

`0.1.1`
* fixed: bootstrap version uninitialized constant

`0.1.0`
* initial version

# License

The MIT License (MIT)

Copyright (c) 2014 Alexey Ovchinnikov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


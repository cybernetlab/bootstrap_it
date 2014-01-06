require 'spec_helper'

describe Bootstrap::ViewHelpers::Pagination do
  it {expect(helper).to render_with 'ul.pagination'}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::List}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::Sizable}
  it {expect(helper {|h| h.link_item 'test', 'http://url'}).to render_with 'ul > li > a[@href="http://url"][text()="test"]'}
end

describe Bootstrap::ViewHelpers::Pager do
  it {expect(helper).to render_with 'ul.pager'}
  it {expect(helper).to be_kind_of Bootstrap::ViewHelpers::List}
  it {expect(helper {|h| h.link_item 'test', 'http://url'}).to render_with 'ul > li > a[@href="http://url"][text()="test"]'}
  it {expect(helper {|h| h.previous 'test', 'http://url'}).to render_with 'ul > li.previous > a[@href="http://url"][text()="test"]'}
  it {expect(helper {|h| h.next 'test', 'http://url'}).to render_with 'ul > li.next > a[@href="http://url"][text()="test"]'}
end

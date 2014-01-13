require 'spec_helper'

# @TODO: dropdownwrapper testing

describe Bootstrap::ViewHelpers::Contextual do
  it {expect(wrapper).to have_enum :state}
  it 'sets state class' do
    %i[active success warning danger].each do |state|
      @wrapper = nil; expect(wrapper state).to render_with "div.#{state}"
      @wrapper = nil; expect(wrapper state: state).to render_with "div.#{state}"
    end
  end
end

describe Bootstrap::ViewHelpers::SizableColumn do
  # column_size_defined?
  it {expect(wrapper.column_size_defined?).to be_false}
  it 'detects if size defined' do
    %i[xs2 sm2 md2 lg2].each do |c|
      @wrapper = nil; expect(wrapper(c).column_size_defined?).to be_true
    end
  end

  it 'sanitize extra small classes' do
    %i[col_xs_2 xs_2 xs2 extra_small_2 extrasmall2].each do |c|
      @wrapper = nil; expect(wrapper c).to render_with 'div.col-xs-2'
      @wrapper = nil; wrapper.column_size = c; expect(wrapper).to render_with 'div.col-xs-2'
    end
  end

  it 'sanitize small classes' do
    %i[col_sm_2 sm_2 sm2 small_2 small2].each do |c|
      @wrapper = nil; expect(wrapper c).to render_with 'div.col-sm-2'
      @wrapper = nil; wrapper.column_size = c; expect(wrapper).to render_with 'div.col-sm-2'
    end
  end

  it 'sanitize medium classes' do
    %i[col_md_2 md_2 md2 medium_2 medium2].each do |c|
      @wrapper = nil; expect(wrapper c).to render_with 'div.col-md-2'
      @wrapper = nil; wrapper.column_size = c; expect(wrapper).to render_with 'div.col-md-2'
    end
  end

  it 'sanitize large classes' do
    %i[col_lg_2 lg_2 lg2 large_2 large2].each do |c|
      @wrapper = nil; expect(wrapper c).to render_with 'div.col-lg-2'
      @wrapper = nil; wrapper.column_size = c; expect(wrapper).to render_with 'div.col-lg-2'
    end
  end

  it '#column_size= accepts sizes as array' do
    wrapper.column_size = [:xs_2, :md_4]
    expect(wrapper).to render_with 'div.col-xs-2.col-md-4'
  end

  it {expect(wrapper :sm3, :sm1).to render_with 'div[@class="col-sm-3"]'}
  it {expect(wrapper :sm12, :lg1).to render_with 'div.col-sm-12.col-lg-1'}
end

describe Bootstrap::ViewHelpers::PlacableColumn do
  %w[offset push pull].each do |act|
    # column_[offset|push|pull]_defined?
    it {expect(wrapper.send "column_#{act}_defined?").to be_false}
    it {expect(wrapper.send "column_place_defined?").to be_false}
    it "detects if #{act} defined" do
      %I[xs_#{act}_2 sm_#{act}_2 md_#{act}_2 lg_#{act}_2].each do |c|
        @wrapper = nil; expect(wrapper(c).send "column_#{act}_defined?").to be_true
        @wrapper = nil; expect(wrapper(c).send "column_place_defined?").to be_true
      end
    end

    it "sanitize extra small #{act}" do
      %I[col_xs_#{act}_2 xs_#{act}_2 extra_small_#{act}_2 extrasmall#{act}2].each do |c|
        @wrapper = nil; expect(wrapper c).to render_with "div.col-xs-#{act}-2"
        @wrapper = nil; wrapper.column_place = c; expect(wrapper c).to render_with "div.col-xs-#{act}-2"
      end
    end
  
    it "sanitize small #{act}" do
      %I[col_sm_#{act}_2 sm_#{act}_2 sm#{act}2 small_#{act}_2 small#{act}2].each do |c|
        @wrapper = nil; expect(wrapper c).to render_with "div.col-sm-#{act}-2"
        @wrapper = nil; wrapper.column_place = c; expect(wrapper c).to render_with "div.col-sm-#{act}-2"
      end
    end
  
    it "sanitize medium #{act}" do
      %I[col_md_#{act}_2 md_#{act}_2 md#{act}2 medium_#{act}_2 medium#{act}2].each do |c|
        @wrapper = nil; expect(wrapper c).to render_with "div.col-md-#{act}-2"
        @wrapper = nil; wrapper.column_place = c; expect(wrapper c).to render_with "div.col-md-#{act}-2"
      end
    end
  
    it "sanitize large #{act}" do
      %I[col_lg_#{act}_2 lg_#{act}_2 lg#{act}2 large_#{act}_2 large#{act}2].each do |c|
        @wrapper = nil; expect(wrapper c).to render_with "div.col-lg-#{act}-2"
        @wrapper = nil; wrapper.column_place = c; expect(wrapper c).to render_with "div.col-lg-#{act}-2"
      end
    end
  end
end

describe Bootstrap::ViewHelpers::Activable do
  it {expect(wrapper).to have_flag(:active).with(html_class: 'active')}
end

describe Bootstrap::ViewHelpers::Disableable do
  it {expect(wrapper).to have_flag(:disabled).with(aliases: [:disable])}
  it {expect(wrapper).to_not render_with '.disabled'}
  it {expect(wrapper :disabled).to render_with '.disabled'}
  it {expect(wrapper tag: :button).to_not render_with '[@disabled]'}
  it {expect(wrapper :disabled, tag: :button).to render_with '[@disabled]'}
  it {expect(wrapper :disabled, tag: :button).to_not render_with '.disabled'}
end

describe Bootstrap::ViewHelpers::Sizable do
  it {expect(wrapper :lg).to render_with ".lg"}
  it {expect(wrapper :large).to render_with ".lg"}
  it {expect(wrapper :sm).to render_with ".sm"}
  it {expect(wrapper :small).to render_with ".sm"}
  it {expect(wrapper :xs).to render_with ".xs"}
  it {expect(wrapper :extrasmall).to render_with ".xs"}
  it {expect(wrapper :extra_small).to render_with ".xs"}
  it {expect(wrapper size: :large).to render_with ".lg"}
  it {expect(wrapper :small, size: :large).to render_with ".sm"}
  it 'adds class prefix' do
    wrapper_class.class_eval do
      self.class_prefix = 'btn'
    end
    @wrapper = nil; expect(wrapper :lg).to render_with '.btn-lg'
    @wrapper = nil; expect(wrapper :btn_lg).to render_with '.btn-lg'
    @wrapper = nil; expect(wrapper :btn_large).to render_with '.btn-lg'
  end
  it {expect(wrapper size: 'value').to_not have_option :size}
end

describe Bootstrap::ViewHelpers::Justifable do
  it {expect(wrapper).to have_flag :justified}
  it {expect(wrapper).to_not render_with '.justified'}
  it {expect(wrapper :justified).to render_with '.justified'}
  it 'adds class prefix' do
    wrapper_class.class_eval {self.class_prefix = 'btn'}
    expect(wrapper :justified).to render_with '.btn-justified'
  end
end

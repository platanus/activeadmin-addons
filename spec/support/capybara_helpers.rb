module CapybaraHelpers
  def on_input_ctx(input_id, &block)
    within("li##{input_id}_input") do
      block.call
    end
  end

  def click_filter_btn
    page.execute_script("document.getElementsByClassName('filter_form')[0].submit()")
  end

  def expect_text(text)
    expect(page).to have_text(text)
  end

  def not_expect_text(text)
    expect(page).not_to have_text(text)
  end

  def expect_css(css)
    expect(page).to have_css(css)
  end

  def click_add_nested
    find("a.has_many_add").click
  end

  def on_nested_ctx(resource_number, &block)
    within("li.has_many_container fieldset:nth-child(#{resource_number + 1}) ") do
      block.call
    end
  end

  def expect_slimselect_options_count_to_eq(count, id = nil)
    id ||= slimselect_original_select_id
    expect(page).to have_css(".ss-content[data-id=#{id}] .ss-option", count: count, visible: :all)
  end

  def slimselect_original_select_id
    find("select[data-id]", visible: false)['data-id']
  end

  def slimselect_element
    find(".ss-main")
  end

  def slimselect_popover(id = nil)
    page.document.find(".ss-content[data-id=#{id || slimselect_original_select_id}]")
  end

  def open_slimselect_options
    slimselect_element.click
    sleep 0.5
  end

  def slimselect_search_input(id = nil)
    slimselect_popover(id).find(".ss-search input")
  end

  def fill_slimselect_input(item_text)
    open_slimselect_options
    slimselect_search_input.set(item_text)
  end

  def slimselect_addable_button
    slimselect_popover.find(".ss-addable")
  end

  def add_slimselect_option(item_text)
    fill_slimselect_input(item_text)
    slimselect_addable_button.click
  end

  def click_slimselect_option(option_text, id = nil)
    slimselect_popover(id).find(".ss-option", text: option_text).click
  end

  def pick_slimselect_entered_option(item_text, display_name = nil)
    display_name ||= item_text
    fill_slimselect_input(item_text)
    click_slimselect_option(display_name)
  end

  def expect_slimselect_data_option(option, value)
    expect(page).to have_xpath("//select[@data-#{option}='#{value}']")
  end

  def expect_slimselect_selection(text)
    expect(page).to have_css(".ss-main", text: /#{text}/)
  end

  def expect_slimselect_empty_selection
    expect(page).to have_css(".ss-main", text: /Select Value/)
  end

  def expect_slimselect_option(text)
    expect(page).to have_css(".ss-option", text: /#{text}/)
  end

  def expect_slimselect_result_text_to_eq(result_number, text)
    expect(page).to have_css(
      "div.ss-option:nth-child(#{result_number})", text: /#{text}/
    )
  end

  def expect_slimselect_no_result
    expect(page).to have_css(
      "div.ss-search", text: 'No Result'
    )
  end

  def expect_slimselect_error(text)
    expect(page).to have_css(".ss-error", text: text)
  end

  def expect_nested_slimselect_result_text_to_eq(result_number, text)
    expect(page).to have_css(
      "li.nested_level:nth-child(#{result_number})", text: /#{text}/
    )
  end

  def close_slimselect_options(id = nil)
    slimselect_search_input(id || slimselect_original_select_id).native.send_keys(:escape)
  end

  def expect_slimselect_popover_is_closed(id = nil)
    expect(page.document).not_to have_css(".ss-content[data-id=#{id || slimselect_original_select_id}]")
  end
end

# frozen_string_literal: true

require 'application_system_test_case'

class PipelinesTest < ApplicationSystemTestCase
  setup do
    @pipeline = pipelines(:one)
  end

  test 'visiting the index' do
    visit pipelines_url
    assert_selector 'h1', text: 'Pipelines'
  end

  test 'creating a Pipeline' do
    visit pipelines_url
    click_on 'New Pipeline'

    fill_in 'Name', with: @pipeline.name
    click_on 'Create Pipeline'

    assert_text 'Pipeline was successfully created'
    click_on 'Back'
  end

  test 'updating a Pipeline' do
    visit pipelines_url
    click_on 'Edit', match: :first

    fill_in 'Name', with: @pipeline.name
    click_on 'Update Pipeline'

    assert_text 'Pipeline was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Pipeline' do
    visit pipelines_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Pipeline was successfully destroyed'
  end
end

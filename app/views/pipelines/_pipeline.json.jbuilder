# frozen_string_literal: true

json.extract! pipeline, :id, :name, :created_at, :updated_at, :script, :repo
json.url pipeline_url(pipeline, format: :json)

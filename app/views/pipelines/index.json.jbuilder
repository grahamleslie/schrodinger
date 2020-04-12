# frozen_string_literal: true

json.array! @pipelines, partial: 'pipelines/pipeline', as: :pipeline

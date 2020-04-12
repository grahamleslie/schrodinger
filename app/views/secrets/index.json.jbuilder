# frozen_string_literal: true

json.array! @secrets, partial: 'secrets/secret', as: :secret

# frozen_string_literal: true

class RunsController < ApplicationController
  # GET /pipelines/1/runs/1
  # GET /pipelines/1/runs/1.json
  def show
    @pipeline = Pipeline.find(params[:id])
    @run = Run.find(params[:run_id])
  end
end

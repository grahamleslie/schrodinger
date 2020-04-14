# frozen_string_literal: true

class RunsController < ApplicationController
  # GET /pipelines/1/runs/1
  # GET /pipelines/1/runs/1.json
  def show
    @pipeline = Pipeline.find(params[:id])
    @run = Run.find(params[:run_id])
  end

  # DELETE /pipelines/1/runs/1
  # DELETE /pipelines/1/runs/1.json
  def destroy
    @pipeline = Pipeline.find(params[:id])
    @run = Run.find(params[:run_id])
    @run.destroy
    respond_to do |format|
      format.html { redirect_to @pipeline, notice: 'Run was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end

# frozen_string_literal: true

class RunsController < ApplicationController
  # GET /pipelines/1/runs/1
  # GET /pipelines/1/runs/1.json
  def show
    @pipeline = Pipeline.find(params[:id])
    @run = Run.find(params[:run_id])
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @run.to_json, status: :ok }
    end
  end

  # POST /pipelines/1/runs
  # POST /pipelines/1/runs.json
  def create
    branch = permitted_params[:branch]
    @pipeline = Pipeline.find(params[:id])
    @run = @pipeline.runs.create({
      num: @pipeline.next_run_num,
      branch: branch,
      triggered_by: 'user'
    })

    respond_to do |format|
      if @run.save
        format.html { redirect_to "/pipelines/#{@pipeline.id}/runs/#{@run.id}" }
        format.json { head :created, json: @run.to_json }
      else
        format.html { render :new }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
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

  private

  def permitted_params
    params.require(:branch)
  end
end

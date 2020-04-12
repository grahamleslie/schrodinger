# frozen_string_literal: true

class PipelinesController < ApplicationController
  before_action :set_pipeline, only: %i[show edit update destroy run]

  # GET /pipelines
  # GET /pipelines.json
  def index
    @pipelines = Pipeline.all.includes(:runs)
  end

  # GET /pipelines/1
  # GET /pipelines/1.json
  def show; end

  # GET /pipelines/new
  def new
    @pipeline = Pipeline.new
  end

  # GET /pipelines/1/edit
  def edit; end

  # GET /pipelines/1/run?branch=master
  def run
    branch = params[:branch]
    @run = @pipeline.runs.create({ num: @pipeline.runs.count + 1, branch: branch, triggered_by: 'user' })
    redirect_to "/pipelines/#{@pipeline.id}/runs/#{@run.id}"
  end

  # GET /pipelines/check
  def check
    CheckForBuildsJob.perform_later
    head :ok
  end

  # POST /pipelines
  # POST /pipelines.json
  def create
    @pipeline = Pipeline.new(pipeline_params)

    respond_to do |format|
      if @pipeline.save
        format.html { redirect_to @pipeline, notice: 'Pipeline was successfully created.' }
        format.json { render :show, status: :created, location: @pipeline }
      else
        format.html { render :new }
        format.json { render json: @pipeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pipelines/1
  # PATCH/PUT /pipelines/1.json
  def update
    respond_to do |format|
      if @pipeline.update(pipeline_params)
        format.html { redirect_to @pipeline, notice: 'Pipeline was successfully updated.' }
        format.json { render :show, status: :ok, location: @pipeline }
      else
        format.html { render :edit }
        format.json { render json: @pipeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pipelines/1
  # DELETE /pipelines/1.json
  def destroy
    @pipeline.destroy
    respond_to do |format|
      format.html { redirect_to pipelines_url, notice: 'Pipeline was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pipeline
    @pipeline = Pipeline.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pipeline_params
    params.require(:pipeline).permit(:name, :repo, :triggers, :domain)
  end
end

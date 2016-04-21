class PomodorosController < ApplicationController
  # GET /pomodoros
  # GET /pomodoros.json
  def index
    @pomodoros = Pomodoro.all
  end

  # GET /pomodoros/1
  # GET /pomodoros/1.json
  def show
    @pomodoro = find_pomodoro
    @timelines = @pomodoro.timelines.latest
    @task = @pomodoro.task
  end

  def timelines
    @pomodoro = find_pomodoro
    @timelines = @pomodoro.timelines.latest

    respond_to do |f|
      f.json { render json: { timelines: @timelines } }
    end
  end

  def stop
    @pomodoro = find_pomodoro
    if @pomodoro.stop!
      respond_to do |f|
        f.html { redirect_to @pomodoro, notice: 'Pomodoro was stopped.' }
        f.json { render json: { status: :success } }
      end
    else
      respond_to do |f|
        f.html { redirect_to @pomodoro, notice: 'Error: Pomodoro stopping failed' }
        f.json { render json: { status: :error } }
      end
    end
  end

  def start
    @pomodoro = find_pomodoro
    if @pomodoro.start!
      redirect_to @pomodoro, notice: 'Pomodoro was started.'
    else
      redirect_to @pomodoro, notice: 'Error: Pomodoro starting failed'
    end
  end

  # POST /pomodoros
  # POST /pomodoros.json
  def create
    @task = find_task
    @pomodoro = Pomodoro.new(task: @task, started_at: now)

    if @pomodoro.save
      redirect_to @pomodoro, notice: 'Start pomodoro'
    else
      redirect_to @task, notice: 'Error: Creating pomodoro failed.'
    end
  end

  # PATCH/PUT /pomodoros/1
  # PATCH/PUT /pomodoros/1.json
  def update
    @pomodoro = find_pomodoro

    respond_to do |format|
      if @pomodoro.update(pomodoro_params)
        format.html { redirect_to @pomodoro, notice: 'Pomodoro was successfully updated.' }
        format.json { render :show, status: :ok, location: @pomodoro }
      else
        format.html { render :edit }
        format.json { render json: @pomodoro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pomodoros/1
  # DELETE /pomodoros/1.json
  def destroy
    @pomodoro = find_pomodoro

    @pomodoro.destroy
    respond_to do |format|
      format.html { redirect_to pomodoros_url, notice: 'Pomodoro was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def find_pomodoro
    Pomodoro.find_by_id!(params[:id] || params[:pomodoro_id])
  end

  def find_task
    Task.find_by_id!(params[:task_id])
  end
end

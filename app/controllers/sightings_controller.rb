class SightingsController < ApplicationController
  before_action :set_sighting, only: [:show, :edit, :update, :destroy]

  # GET /sightings
  # GET /sightings.json
  def index
    if params[:start_date].present?
      @sightings = Sighting.where(date: params[:start_date]..params[:end_date])
      render('sightings/index.html.erb')
    elsif params[:region].present?
      @sightings = Sighting.where(region: params[:region])
      render('sightings/index.html.erb')
    else
      @sightings = Sighting.all
    end
  end

  # GET /sightings/1
  # GET /sightings/1.json
  def show
  end

  # GET /sightings/new
  def new
    @sighting = Sighting.new
    if params[:animal_id].present?
      @sighting.animal = Animal.find(params[:animal_id])
    end
    @animals_for_select = Animal.all.map do |animal|
      [animal.name, animal.id]
    end


  end

  # GET /sightings/1/edit
  def edit
    @animals_for_select = Animal.all.map do |animal|
      [animal.name, animal.id]
    end
  end

  # POST /sightings
  # POST /sightings.json
  def create
    @sighting = Sighting.new(sighting_params)
    @animals_for_select = Animal.all.map do |animal|
      [animal.name, animal.id]
    end

    respond_to do |format|
      if @sighting.save
        format.html { redirect_to @sighting, notice: 'Sighting was successfully created.' }
        format.json { render :show, status: :created, location: @sighting }
      else
        format.html { render :new }
        format.json { render json: @sighting.errors, status: :unprocessable_entity }
      end

    end
  end

  # PATCH/PUT /sightings/1
  # PATCH/PUT /sightings/1.json
  def update
    respond_to do |format|
      if @sighting.update(sighting_params)
        format.html { redirect_to @sighting, notice: 'Sighting was successfully updated.' }
        format.json { render :show, status: :ok, location: @sighting }
      else
        format.html { render :edit }
        format.json { render json: @sighting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sightings/1
  # DELETE /sightings/1.json
  def destroy
    @sighting.destroy
    respond_to do |format|
      format.html { redirect_to sightings_url, notice: 'Sighting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def calendar
  end

  def get_sightings
    @sightings = Sighting.all
    events = []
    @sightings.each do |sighting|
      events << { title: sighting.animal.name+"/"+sighting.region, start: sighting.date, allDay: true, time: sighting.time, latitude: sighting.latitude, longitude: sighting.longitude, region: sighting.region }
    end
    render :json => events.to_json

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sighting
      @sighting = Sighting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sighting_params
      params.require(:sighting).permit(:animal_id, :date, :time, :latitude, :longitude, :region)
    end
end

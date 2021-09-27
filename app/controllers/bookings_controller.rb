class BookingsController < ApplicationController
  @@env = Spreedly::Environment.new(ENV["CORE_ENVIRONMENT_KEY"], ENV["CORE_ACCESS_SECRET"])
  @@gateway = @@env.find_gateway(ENV["GATEWAY_KEY"])

  def new
    @booking = Booking.new
    @flight = Flight.find(params[:flight_id])
    @num_passengers = params[:num_passengers].to_i
    @total_price = @flight.price * @num_passengers
    @num_passengers.times {@booking.passengers.build}
    @credit_cards = @@env.list_payment_methods
  end

  def create

    begin
      puts params[:payment_method_token]
      @flight = Flight.find(booking_params[:flight_id].to_i)
      @num_passengers = params[:booking][:num_passengers].to_i
      @total_price = @flight.price * @num_passengers
      trx = @@env.purchase_on_gateway(@@gateway.token, params[:payment_method_token], @total_price.to_i * 100)
      if params[:storage_state]
        @@env.retain_payment_method(params[:payment_method_token])
      end
      if trx.succeeded?
        @booking = Booking.new(booking_params)
        @booking.trx_id = trx.token
        if @booking.save
          flash[:success] = "Booked!"
          @@env.deliver_to_receiver(
            ENV["RECEIVER_KEY"],
            params[:payment_method_token],
            headers: { "Content-Type": "application/json" },
            url: "https://spreedly-echo.herokuapp.com",
            body: {'test': 'test'}
          )
          redirect_to @booking
        else
        flash[:error] = trx.message
        @booking = Booking.new
        @num_passengers.times {@booking.passengers.build}
        render :new
        end
      else
        flash[:error] = trx.message
        @booking = Booking.new
        @num_passengers.times {@booking.passengers.build}
        render :new
        end
      end
    rescue Exception => ex
      flash[:error] = ex.message
      @booking = Booking.new
      @num_passengers.times {@booking.passengers.build}
      render :new
    end


  def index
    @bookings = Booking.all
    @transactions = @@env.list_transactions

    puts @transactions.last.token
    puts @transactions.last.succeeded
  end

  def show
    @booking = Booking.find(params[:id])
  end

  private
    def booking_params
      params.require(:booking).permit(:flight_id, passengers_attributes: [:id, :name, :email, :booking_id])
    end

    def credit_card_params
      params.require(:credit_card).permit(:first_name, :last_name, :number, :month, :year, :storage_state)
    end
end

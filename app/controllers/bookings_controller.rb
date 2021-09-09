class BookingsController < ApplicationController
  @@env = Spreedly::Environment.new(ENV["CORE_ENVIRONMENT_KEY"], ENV["CORE_ACCESS_SECRET"])
  @@gateway = @@env.find_gateway('VjdAvFJWOj6mqmjd1UxgP4AQRfb')

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
      #try to add credit card, if it fails then render new with why credit card is invalid
      @flight = Flight.find(booking_params[:flight_id].to_i)
      @num_passengers = params[:booking][:num_passengers].to_i
      @total_price = @flight.price * @num_passengers
      @credit_cards = @@env.list_payment_methods
      if params[:card_to_use].blank?
        #new card
        cc = @@env.add_credit_card(credit_card_params)
        if credit_card_params[:storage_state]
          @@env.retain_payment_method(cc.payment_method.token)
        end
        trx = @@env.purchase_on_gateway(@@gateway.token, cc.payment_method.token, @total_price.to_i * 100)
      else
        #existing card
        cc = @@env.find_payment_method(params[:card_to_use])
        trx = @@env.purchase_on_gateway(@@gateway.token, cc.token, @total_price.to_i * 100)
      end

      if trx.succeeded?
        @booking = Booking.new(booking_params)
        @booking.trx_id = trx.token
        if @booking.save
          flash[:success] = "Created!"
          #deliver to PMD if a vaulted card and existing card
          if cc.storage_state == 'retained'
            @@env.deliver_to_receiver(
              'DtUGltJd9Djt7A6sx296odPMsLr',
              cc.token,
              headers: { "Content-Type": "application/json" },
              url: "https://spreedly-echo.herokuapp.com",
              body: { card_number: credit_card_params[:number] }.to_json
            )
            #deliver to PMD if a vaulted card and new card
          elsif cc.payment_method.storage_state == 'retained'
            @@env.deliver_to_receiver(
              'DtUGltJd9Djt7A6sx296odPMsLr',
              cc.payment_method.token,
              headers: { "Content-Type": "application/json" },
              url: "https://spreedly-echo.herokuapp.com",
              body: { card_number: credit_card_params[:number] }.to_json
            )
          end
          redirect_to @booking
        else
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
    rescue Exception => ex
      flash[:error] = ex.message
      @booking = Booking.new
      @num_passengers.times {@booking.passengers.build}
      render :new
    end
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

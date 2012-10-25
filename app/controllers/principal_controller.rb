class PrincipalController < ApplicationController

	def index
	end 

	def solicitando

		#Por si meten informacion en una peticion POST
		unless params[:presion] && params[:temperatura] && params[:codigo]
			flash[:error]="Falta Parametros"
			redirect_to :action=>"index"
			return		
		end

		presion=params[:presion] 		
		temperatura=params[:temperatura]
		codigo=params[:codigo]

		#validacion si el campo esta vacio
		if codigo.empty?
			flash[:error]="Falta llenar el campo codigo"
			redirect_to :action=>"index"
			return
		end

		if temperatura.empty?
			flash[:error]="Falta llenar el campo temperatura"
			redirect_to :action=>"index"
			return
		end

		if presion.empty?
			flash[:error]="Falta llenar el campo presion"
			redirect_to :action=>"index"
			return
		end

		#Validacion si el campo no es numerico
		#Tiene que ver el Modelo (app/models/numero.rb)
		#para entender de donde sale la funcion is_numeric
		if not Numero.is_numeric?(temperatura)
			flash[:error]="La temperatura debe ser un entero entre -50 y 100"
			redirect_to :action=>"index"
			return
		end

		if not Numero.is_numeric?(presion)
			flash[:error]="La presion debe ser un entero entre 0 y 500"
			redirect_to :action=>"index"
			return
		end
		#validando un codigo correcto
		if not codigo.eql?("00-01") and not codigo.eql?("00-002") and not codigo.eql?("00-03")
			flash[:error]="El codigo debe tener los valores : 00-01,00-002 y 00-03"
			redirect_to :action=>"index"
			return
		end

		#validando presion correcta
		if presion.to_i <0 or presion.to_i >500
			flash[:error]="La presion debe estar entre 0 y 500"
			redirect_to :action=>"index"
			return
		end

		#validando temperatura correcta
		if temperatura.to_i< -50 or temperatura.to_i>100
			flash[:error]="La temperatura debe estar entre -50 y 100"
			redirect_to :action=>"index"
			return
		end

		
		#aqui verifico el servidor , el begin es inicio de una captura de excepcion
		#como el try y catch
		begin
			#Creo comunicacion con el servicio web
			cliente = Savon::Client.new("http://localhost:3001/servicio/wsdl")

			#mando los datos ala funcion del servicio web
			result = cliente.request(:informacion_dispositivo) do
				soap.body = { :codigo => codigo, :temperatura => temperatura ,:presion => presion}
			end
			result=result.to_hash
			result=result[:informacion_dispositivo_response][:mensaje]

			@codigo=result[:codigo]
			@salud_presion=result[:mensaje_presion]
			@salud_temperatura=result[:mensaje_temperatura]
			@tiempo=Time.now.to_s.split[1]
			
		rescue
			#si ocurre algo en el servidor muestro error del servicio web
			flash[:error]="Problemas en el Servicio Web"
			redirect_to :action =>"index"
			return	
		end	


		
	end

end

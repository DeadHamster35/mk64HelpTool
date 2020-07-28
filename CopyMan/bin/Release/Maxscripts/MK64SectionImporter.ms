lineReader = ""
vertfile = #()
object_array = #()
garbage = "string"
vertname = "string"
position = #()
offsetValue = 0


	rollout MK64Section "S-Importer" width:175 height:68
		(
			GroupBox grp3 "S-Importer" pos:[5,0] width:165 height:62
			label Lbl "<3 Hamp" enabled:false pos:[10,53]
			button impBtn "Import" pos:[10,20] width:60 height:25
			checkbox split "Split Sections" pos:[75,25] checked:true


			on duckDodget open do
			(

				ClearListener()


			)



			on impBtn pressed do
			(
				clearlistener()
				Print "Startup Import"
				in_name = getOpenFileName \
					filename: "" \
					types: "TXT File (*.txt)|*.txt|All Files (*.*)|*.*"
				if in_name != undefined then
				(

					in_file = openfile in_name

					if in_file != undefined then
					(
						m = 0
						n = 0
						i = 1
						linecurrent = 1.0

						local line_cnt = 0
						while not eof in_file do
						(
							readLine in_file
							line_cnt += 1
						)
						in_file = openfile in_name

						while not eof in_file do
						(




							linecurrent = linecurrent + 1


							lineReader = readLine in_file as string
							if (lineReader == "ENDSECTION") then
							(
								if (currentobject == undefined) then
								(
									garbage = readLine in_file as string
								)
								else
								(
									if split.Checked == true do
									(
										currentobject.pos = [offsetValue,0,0]
										offsetValue = offsetValue + 1000
									)
									currentobject.name = readLine in_file as string
									currentobject = undefined



									object_array = undefined
									object_array = #()
									i=1


									gc()



									linecurrent = linecurrent + 1

									lineperc = 0.0
									lineperc = ((linecurrent / line_cnt) * 100)
									printperc = lineperc as string
									printstring = printperc+ "% -  " +linecurrent as string+"/"+line_cnt as string
									Print printstring


									windows.processPostedMessages()
								)

							)
							else
							(

								if (lineReader == "NEWOBJECT") or (lineReader == "ENDOBJECT") then
								(
									if i > 1 then
									(

										if split.Checked == true do
										(
											vertbox.pos = [n*10000,m*10000,0]
										)
										vertbox.name = vertname

										vertbox = undefined

										object_array = undefined
										object_array = #()
										i=1
									)
									garbage = readLine in_file as string
									vertname = readLine in_file as string
									linecurrent = linecurrent + 1
									linecurrent = linecurrent + 1
								)
								else
								(
									facelist = FilterString lineReader ";"


									for face in facelist do
									(
										vert = FilterString face ","

										join position vert

									)



									vertbox = mesh vertices:#([position[1] as float,position[2] as float,position[3] as float],[position[4] as float,position[5] as float,position[6] as float],[position[7] as float,position[8] as float,position[9] as float]) faces:#([1,2,3]) MaterialIDS:#(1)
									object_array[i] = vertbox
									position.Count = 0


									if (i > 1) do
									(
										meshop.attach object_array[i] object_array[i-1]
										currentobject = object_array[i]
									)

									i=i+1
								)
							)
						)






					)
				)
				MessageBox "Finished"
				close in_file
				gc()

			)





		)
CreateDialog MK64Section

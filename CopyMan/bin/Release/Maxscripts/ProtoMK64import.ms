file=""
file_name=""


maxver = maxVersion()

----------------------------------------------------------------------------------------------------
-- HRS Importer
-- <3 hamp
----------------------------------------------------------------------------------------------------


Global x = 0
Global y = 0
Global z = 0
Global vertfile = #()
vert_count = 0
vert_array = #()
face_array = #()

vertData = #()
dataInput = ""
object_array = #()
garbage = ""
vertname = ""
xArray = #()
yArray = #()
zArray = #()

object_array = #()

vertbox = mesh

Global line_count = 0





	rollout DuckDodget "-Importer" width:80 height:68
		(
			GroupBox grp3 "Importer" pos:[3,0] width:75 height:62
			label Lbl "<3 Hamp" enabled:false pos:[10,53]
			button impBtn "Import" pos:[10,20] width:60 height:25



			on duckDodget open do
			(

				ClearListener()
				temp_buffer = fopen (sysInfo.tempdir + "\\float_conv_buffer.bin") "wb+"

			)



			on impBtn pressed do
			(
				in_name = getOpenFileName \
					filename: "" \
					types: "TXT File (*.txt)|*.txt|All Files (*.*)|*.*"
				if in_name != undefined then
				(
					currentLine = 0
					in_file = openfile in_name

					if in_file != undefined then
					(
						i = 1


						while (not eof in_file) do
						(
							Print "Startup Import"
							currentVert = 1


							dataInput = readLine in_file as string
							currentLine = currentLine + 1
							print ("Current Line "+currentLine as string)
							print readLine
							dataInput = FilterString dataInput " "

							if (dataInput[2] == "PointData") then
							(

								vertArray =#()
								break = false
								while (break == false) do
								(
									if (eof in_file) then
									(
										break = true
									)
									else
									(
										dataInput = readLine in_file as string
										currentLine = currentLine + 1
										print ("Current Line "+currentLine as string)
										print readLine
										if (dataInput != "};") then
										(
											dataInput = substituteString dataInput "{" ""
											dataInput = substituteString dataInput "}" ""
											vertData = FilterString dataInput ","
											print vertData
											vertArray[currentVert] = [vertData[1] as float,vertData[3] as float,vertData[2] as float]
											currentVert = currentVert + 1
										)
										else
										(
											print ("Break "+ currentLine as String)
											break = true
										)
									)
								)
							)
							else if (dataInput[2] == "FaceData") then
							(
								i = 1
								break = false
								while (break == false) do
								(
									if (eof in_file) then
									(
										break = true
									)
									else
										(
										dataInput = readLine in_file as string
										currentLine = currentLine + 1
										print ("Current Line "+currentLine as string)
										print readLine
										if (dataInput != "};") then
										(
											dataInput = FilterString dataInput ","
											dataInput[1] = substituteString dataInput[1] "{" ""
											dataInput[13] = substituteString dataInput[13] "{" ""
											dataInput[13] = substituteString dataInput[13] "}" ""
											dataInput[13] = substituteString dataInput[13] " " ""
											dataInput[dataInput.count] = substituteString dataInput[dataInput.count] "}" ""
											dataInput[dataInput.count] = substituteString dataInput[dataInput.count] " " ""

											indexData = dataInput
											print "Index Data"
											print indexData
											print index
											indexCount = indexData[1] as integer


											vertPositions = #()
											currentIndex = 1 as integer
											print "IndexCount"
											print indexCount
											while (currentIndex <= indexCount) do
											(
												arraySearch = (indexData[currentIndex + 12] as integer + 1)
												vertPositions[currentIndex] = vertArray[arraySearch]
												currentIndex = currentIndex + 1
											)
											print "Vert Data"
											print vertPositions

											modelIndexes = #()
											currentIndex = 1 as integer

											if (indexCount == 3) then
											(
												modelIndexes[1] = [1, 2, 3]
											)
											else if (indexCount ==4) then
											(
												modelIndexes[1] = [1, 2, 3]
												modelIndexes[2] = [1, 3, 4]
											)
											else if (indexCount == 5) then
											(
												modelIndexes[1] = [1, 2, 3]
												modelIndexes[2] = [1, 3, 4]
												modelIndexes[3] = [1, 4, 5]
											)
											else if (indexCount == 6) then
											(
												modelIndexes[1] = [1, 2, 3]
												modelIndexes[2] = [1, 3, 4]
												modelIndexes[3] = [1, 4, 5]
												modelIndexes[4] = [1, 5, 6]
											)
											else if (indexCount == 7) then
											(
												modelIndexes[1] = [1, 2, 3]
												modelIndexes[2] = [1, 3, 4]
												modelIndexes[3] = [1, 4, 5]
												modelIndexes[4] = [1, 5, 6]
												modelIndexes[5] = [1, 6, 7]
											)
											else if (indexCount == 8) then
											(
												modelIndexes[1] = [1, 2, 3]
												modelIndexes[2] = [1, 3, 4]
												modelIndexes[3] = [1, 4, 5]
												modelIndexes[4] = [1, 5, 6]
												modelIndexes[5] = [1, 6, 7]
												modelIndexes[6] = [1, 7, 8]
											)

											vertbox = mesh vertices:vertPositions faces:modelIndexes
											object_array[i] = vertbox

											if (i > 1) then
											(
												meshop.attach object_array[i] object_array[i-1]
											)
											i = i + 1
											currentIndex = currentIndex + 1
										)
										else
										(
											break = true
										)
									)
								)
							)

						)
					)

					close in_file

					gc()
					clearUndoBuffer()



				)




			)





		)
CreateDialog DuckDodget

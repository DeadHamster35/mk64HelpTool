file=""
file_name=""

maxver = maxVersion()

----------------------------------------------------------------------------------------------------
-- MK64 Vertex Importer
-- <3 hamp
----------------------------------------------------------------------------------------------------


Global x = 0
Global y = 0
Global z = 0
Global vertfile = #()

path_count = 0
vert_count = 0
vert_array = #()
face_array = #()



vertbox = mesh

Global line_count = 0





rollout MK64Vimport "V-Importer" width:80 height:85
	(
		GroupBox grp3 "V-Importer" pos:[3,0] width:75 height:80
		label Lbl "<3 Hamp" enabled:false pos:[10,53]
		button impBtn "Import" pos:[10,20] width:60 height:25
		button expBtn "Export" pos:[10,50] width:60 height:25



		on MK64Vimport open do
		(

			ClearListener()
			temp_buffer = fopen (sysInfo.tempdir + "\\float_conv_buffer.txt") "wb+"

		)



		on impBtn pressed do
		(
			Print "Startup Import"
			in_name = getOpenFileName \
				filename: "" \
				types: "TXT File (*.txt)|*.txt|All Files (*.*)|*.*"
			if in_name != undefined then
			(

				in_file = openfile in_name

				if in_file != undefined then
				(

					i=0
					while not eof in_file do
					(

						dataInput = readLine in_file
						dataInput = substituteString dataInput "]" ""
						dataInput = substituteString dataInput "[" ""
						dataInput = FilterString dataInput ","



						mybox = box length:25 width:25 height:25
						mybox.pos=[dataInput[1] as float,dataInput[2] as float,dataInput[3] as float]
						mybox.name = i as string
						i=i+1
					)


					mybox = box length:15 width:15 height:15
					mybox.pos=[i,0,0]
					mybox.name = "vertcount" as string

					close in_file
				)
			)
		)

		on expbtn pressed do
		(

			output_name = getSaveFileName caption:"Exporting Verts" \
			filename: "" \
			types:"TXT (*.txt)|*.txt|All Files (*.*)|*.*|"

			i = 0

			if output_name == undefined then
			(

			)
			else
			(
				txt = createfile output_name


				searchstring = "vertcount"
				sourceobj = getNodeByName searchstring exact:true
				vertcount = sourceobj.pos.x

				total_instance_count=0

				while i < vertcount do
				(


					searchstring = i as string
					sourceobj = getNodeByName searchstring exact:true
					printstring = (sourceobj.pos.x*-1) as string +","+(sourceobj.pos.y) as string +","+(sourceobj.pos.z) as string
					format printstring to:txt
					format "\n" to:txt
					i= i+1
				)



				close txt


			)
		)

		-- End of rollout
	)
CreateDialog MK64Vimport

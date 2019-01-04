local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'

function testView2()

	LrFunctionContext.callWithContext( "showCustomDialogWithMultipleBind", function( context )
			
			-- Create two observable tables.
			
			local tableOne = LrBinding.makePropertyTable( context ) -- This will be bound to the view
			local tableTwo = LrBinding.makePropertyTable( context )
			
			-- Add a property to each table.
			
			tableOne.sliderOne = 0
			tableTwo.sliderTwo = 50
			
			local f = LrView.osFactory()
			
			local c = f:column {
			
				bind_to_object = tableOne, -- bind tableOne
				spacing = f:control_spacing(),
			
				f:row {
					f:group_box {
						title = "Slider One",
						font = "<system>",
						f:slider {
							value = LrView.bind( "sliderOne" ),
							min = 0,
							max = 100,
							width = LrView.share( "slider_width" )
						},
						
						f:edit_field {
							place_horizontal = 0.5,
							value = LrView.bind( "sliderOne" ),
							width_in_digits = 7
						},
					},
					
					f:group_box {
						title = "Slider Two",
						font = "<system>",
						f:slider {
							bind_to_object = tableTwo,
							value = LrView.bind( "sliderTwo" ),
							min = 0,
							max = 100,
							width = LrView.share( "slider_width" )
						},
	
						f:edit_field {
							place_horizontal = 0.5,
							bind_to_object = tableTwo,
							value = LrView.bind( "sliderTwo" ),
							width_in_digits = 7
						}
					},
				},
					
				f:group_box {
					fill_horizontal = 1,
					title = "Both Values",
					font = "<system>",
				
					f:edit_field{
						place_horizontal = 0.5,
						value = LrView.bind {
						
							-- Supply a table with table keys.
							
							keys = {
									{
										-- Only the key name is needed as sliderOne in tableOne and that is already bound.
										
										key = "sliderOne"
									},
									{
										-- We need to supply the key and the table to which it belongs.
										
										key = "sliderTwo",
										bind_to_object = tableTwo
									}
								},
								
							-- This operation will create the value for this edit_field.
							-- The bound values are accessed with the arg 'values'.
							operation = function( _, values, _ )
								return values.sliderTwo + values.sliderOne
							end
						},
						width_in_digits = 7
					},
				}
			}
			
			LrDialogs.presentModalDialog {
				title = "Custom Dialog Multiple Bind",
				contents = c
			}
			
		end )
end

testView2()
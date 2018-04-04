onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/clk
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/reset
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/PortIn
add wave -noupdate -radix decimal /MIPS_Processor_TB/ALUResultOut
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/PortOut
add wave -noupdate -divider -height 20 {Program Counter}
add wave -noupdate /MIPS_Processor_TB/DUV/ProgramCounter/NewPC
add wave -noupdate -radix unsigned -radixshowbase 0 /MIPS_Processor_TB/DUV/ProgramCounter/PCValue
add wave -noupdate -divider -height 20 {Reg v0}
add wave -noupdate /MIPS_Processor_TB/DUV/Register_File/Register_v0/DataOutput
add wave -noupdate -divider {ALU Result}
add wave -noupdate -radix hexadecimal /MIPS_Processor_TB/DUV/ArithmeticLogicUnit/ALUResult
add wave -noupdate /MIPS_Processor_TB/DUV/ArithmeticLogicUnit/A
add wave -noupdate /MIPS_Processor_TB/DUV/ArithmeticLogicUnit/B
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 200
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {21 ps} {33 ps}

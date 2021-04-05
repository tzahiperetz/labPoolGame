
module imoji (
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic draw , // draw only when the controller ask

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);

localparam  int OBJECT_WIDTH_X = 50;
localparam  int OBJECT_HEIGHT_Y = 50;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 


logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF9, 8'hF5, 8'hF5, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hF9, 8'hFA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF9, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hF9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hF9, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF9, 8'hF9, 8'hFA, 8'hFA, 8'hFA, 8'hF9, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF5, 8'hF9, 8'hFA, 8'hFA, 8'hF9, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hFA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF9, 8'hF8, 8'hF8, 8'hF8, 8'hFA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF9, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF5, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hF9, 8'hF8, 8'hF8, 8'hF9, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF5, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF9, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF9, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF9, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF5, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFE, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'h89, 8'h84, 8'hAD, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF5, 8'hDF, 8'hFF, 8'hFF, 8'hFB, 8'h88, 8'h84, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hF9, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hD6, 8'h84, 8'h84, 8'h84, 8'hFB, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFF, 8'hFF, 8'hFF, 8'hD6, 8'h84, 8'h84, 8'hAD, 8'hFF, 8'hFF, 8'hFF, 8'hF9, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFE, 8'hFF, 8'hFF },
{8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h84, 8'h64, 8'h89, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hDF, 8'hFF, 8'hFF, 8'hDA, 8'h84, 8'h84, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hF5, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFA, 8'hFF, 8'hFF },
{8'hFF, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hDA, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hB1, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF5, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFF, 8'hFF },
{8'hFF, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF5, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF5, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFE, 8'hFF },
{8'hFF, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF4, 8'hDA, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'hF5, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF5, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFA, 8'hFF },
{8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF4, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF5, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hF5, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFF },
{8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'hF4, 8'hF5, 8'hDA, 8'hDB, 8'hDB, 8'hDB, 8'hDA, 8'hF5, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'hF5, 8'hDA, 8'hDA, 8'hDA, 8'hF9, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFF },
{8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'hF4, 8'hF5, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFF },
{8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFF },
{8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFE },
{8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFE },
{8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'hF4, 8'hF4, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF9, 8'hF9, 8'hF9, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFE },
{8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF5, 8'hF5, 8'hD5, 8'hD5, 8'hD6, 8'hDA, 8'hDA, 8'hDA, 8'hDB, 8'hDA, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDA, 8'hDA, 8'hDA, 8'hDA, 8'hD9, 8'hD5, 8'hF5, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFE },
{8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hD5, 8'hB6, 8'hB6, 8'hDB, 8'hDB, 8'hDB, 8'hBB, 8'hBB, 8'hDB, 8'hDB, 8'hDF, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hB6, 8'hB6, 8'hDA, 8'hD5, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hFE },
{8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hDA, 8'hBB, 8'hB6, 8'hB6, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hB6, 8'hB6, 8'hBB, 8'hBB, 8'hD5, 8'hF8, 8'hF8, 8'hF8, 8'hFE },
{8'hFE, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hD5, 8'hBB, 8'hBB, 8'hB6, 8'hB6, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDF, 8'hDF, 8'hDF, 8'hDF, 8'hDF, 8'hDF, 8'hDF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hDF, 8'hBA, 8'hB6, 8'hBB, 8'hBB, 8'hDA, 8'hF4, 8'hF8, 8'hF9, 8'hFF },
{8'hFF, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hD6, 8'hBB, 8'hDB, 8'hB6, 8'hBB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hBB, 8'hF5, 8'hF8, 8'hF9, 8'hFF },
{8'hFF, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hD6, 8'hBB, 8'hB6, 8'hB6, 8'hB6, 8'hBA, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hBA, 8'hBB, 8'hBB, 8'hBB, 8'hD5, 8'hF8, 8'hF9, 8'hFF },
{8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hD5, 8'hB6, 8'hB6, 8'hB6, 8'hBB, 8'hDB, 8'hDF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hB6, 8'hB6, 8'hD5, 8'hF8, 8'hFA, 8'hFF },
{8'hFF, 8'hFF, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF5, 8'hDB, 8'hDB, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDA, 8'hF4, 8'hF8, 8'hFE, 8'hFF },
{8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hDA, 8'hDB, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hDF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFA, 8'hF4, 8'hF9, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF5, 8'hDA, 8'hB6, 8'hDA, 8'hFF, 8'hFF, 8'hFB, 8'hDA, 8'hDA, 8'hFA, 8'hFA, 8'hFA, 8'hF9, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF5, 8'hF9, 8'hF9, 8'hF9, 8'hFA, 8'hFA, 8'hFA, 8'hFA, 8'hFB, 8'hDB, 8'hDA, 8'hDB, 8'hDB, 8'hDA, 8'hF4, 8'hF4, 8'hFA, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF5, 8'hF5, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF5, 8'hF5, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF9, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hFA, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hFA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hFA, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hFA, 8'hF9, 8'hF5, 8'hF4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF9, 8'hF9, 8'hFA, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'hFF;
	end
	else begin
		if ((draw == 1) && (InsideRectangle == 1'b1) )  // inside an external bracket 
			RGBout <= object_colors[offsetY][offsetX];	//get RGB from the colors table  
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule




<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title></title>
</head>
<body>
<table border="0" summary="">
	<tr>
	<td width="359">
	<table>
		<tr>
		<td><b>Inputs</b></td>
		</tr>		
		<tr>
		<td>Analogue 1:</td>        
        	<td>%01</td>
        	<td>Analogue 2:</td>
        	<td>%02</td>
    		</tr>
    		<tr>
        	<td>Analogue 3:</td>
        	<td>%03</td>
        	<td>Analogue 4:</td>
        	<td>%04</td>
    		</tr>
	</table>

	<table cellpadding="2">
    		<tr>
        	<td>Digital 1-8 :</td>
        	<td>%05</td>
    		</tr>
    		<tr>
        	<td>Digital 9-16:</td>
        	<td>%06</td>
    		</tr>
	</table>
	<table>
    		<tr>
        	<td><b>Ouputs</b></td>
    		</tr>
    		<tr>
        	<td>Digital 1-8 :</td>
        	<td>%07</td>
    		</tr>
    		<tr>
        	<td>Digital 9-16:</td>
        	<td>%08</td>
    		</tr>
	</table>
	<table>
    		<tr>
        	<td>Serial:</td>
        	<td>%00</td>
    		</tr>
	</table>
	</td>
	<td><FORM METHOD=GET action="status.cgi">
	<form>
	<table>
		<tr>
        	<td><b>Commands</b></td>
    		</tr>
    		<tr>
        	<td><input type=submit name=T01 value=" Toggle 1 "></td>
        	<td><input type=submit name=T02 value=" Toggle 2 "></td>
        	<td><input type=submit name=T03 value=" Toggle 3 "></td>
        	<td><input type=submit name=T04 value=" Toggle 4 "></td>
		</tr>
    		<tr>
        	<td><input type=submit name=T05 value=" Toggle 5 "></td>
        	<td><input type=submit name=T06 value=" Toggle 6 "></td>
        	<td><input type=submit name=T07 value=" Toggle 7 "></td>
        	<td><input type=submit name=T08 value=" Toggle 8 "></td>
		</tr>
		<tr>
        	<td><input type=submit name=T09 value=" Toggle 9 "></td>
        	<td><input type=submit name=T10 value="Toggle 10"></td>
        	<td><input type=submit name=T11 value="Toggle 11"></td>
        	<td><input type=submit name=T12 value="Toggle 12"></td>
		</tr>
		<tr>
        	<td><input type=submit name=T13 value="Toggle 13"></td>
        	<td><input type=submit name=T14 value="Toggle 14"></td>
        	<td><input type=submit name=T15 value="Toggle 15"></td>
        	<td><input type=submit name=T16 value="Toggle 16"></td>
		</tr>
	</table>
	<table>
		<tr>
		<td>Serial:<input type="text" name="S00"></td>
		<td><input type=submit value="Send"></td>
		</tr>
	</table>
	<table>
        	<td><input type=submit value="Refresh"></td>
	</table>
	</form>
</table>
</body>
</html>
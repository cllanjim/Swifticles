<?php
$con = mysql_connect("unionbeer.db.6143131.hostedresource.com", "hypernova", "Hyp3r#N0va");
if($con)
{
	mysql_select_db('unionbeer');
    if($id != null)
    {
        $result = mysql_query("INSERT INTO images (imageURL, width, height) VALUES ('www.yahoo.com', '200', '300');");
    }
	mysql_close($con);
}
?> 

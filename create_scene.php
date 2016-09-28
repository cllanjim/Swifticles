<?php
    $name = $_GET['name'];
    $image_id = $_GET['imageid'];
    $thumb_id = $_GET['thumbid'];
    $con = mysql_connect("hypernova.db.6143131.hostedresource.com", "hypernova", "Hyp3r#N0va");
    if($con) {
        mysql_select_db('hypernova');
        $result = mysql_query("INSERT INTO scene (name, image_id, thumb_id) VALUES ('$name', '$image_id', '$thumb_id');");
        $lastID = mysql_insert_id();
        $output = array('name' => $name, 'id' => $lastID, 'image_id' => $image_id, 'thumb_id' => $thumb_id);
        echo json_encode($output);
        mysql_close($con);
    } else {
        $output = array('error' => 'mysql connection problem');
        echo json_encode($output);
    }
?>


<?php
$sql="SELECT $popcode, $popname FROM $poptable WHERE $popwhere $poporder";
$result = $mysqli->query($sql);
while($row = $result->fetch_row()) {
echo '<option value="' . $row['0'] . '">' . $row['1'] . "</option>";
}
?>
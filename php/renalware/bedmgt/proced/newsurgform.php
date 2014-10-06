<?php
//----Tue 11 Sep 2012----surgeons popup change
//Renal Bed Management System
//for copyright info see renalbedmgt_info.php
//get zid
//have to pass different ways
if ($_GET['zid'])
	{
	$zid=(int)$_GET['zid'];
	$newpzid=(int)$_GET['zid'];
	}
if ($zid)
	{
	$newpzid=$zid;
	}
//get patdata
include 'proced/getpatdata_incl.php';
$sql="SELECT hospno1, modalcode, firstnames, lastname, DATE_FORMAT(birthdate, '%d/%m/%Y') AS birthdate_dmy FROM renalware.patientdata WHERE patzid=$newpzid";
$result = $mysqli->query($sql);
$row = $result->fetch_assoc();
$hospno=$row["hospno1"];
$modal=$row["modalcode"];
$patientref=$row["firstnames"] . ' ' . $row["lastname"] . ' (Hosp No. ' . $hospno . ' DOB: ' . $row["birthdate_dmy"] .')';
$patient=$row["firstnames"] . ' ' . $row["lastname"];
$legend="Request procedure for $patientref";
?>
<table border="0" cellspacing="5" cellpadding="5">
<tr><td valign="top">
<form action="run/runrequest2.php" method="post">
<input type="hidden" name="mode" value="add" id="mode" />
<input type="hidden" name="pzid" value="<?php echo $newpzid; ?>" id="pzid" />
<input type="hidden" name="hospno" value="<?php echo $hospno; ?>" id="hospno" />
<input type="hidden" name="modal" value="<?php echo $modal; ?>" id="modal" />
<?php if ($get_tcilist_id): ?>
	<input type="hidden" name="tcilist_id" value="<?php echo $get_tcilist_id; ?>" id="tcilist_id" />
<?php endif ?>
<fieldset>
	<legend><?php echo $legend; ?></legend>
	<p>To CANCEL this request use your browser's BACK button or <a href="javascript:history.go(-1)">click here</a></p>
	<p>IMPORTANT: Procedures can only be added by pop-up menu selection. <a href="index.php?vw=user&amp;scr=fixprocedslist" target="new">Add New Procedure (new window)</a></p>
<table>
<tr><td class="fldview">Listed Date</td><td class="data"><input type="text" name="listeddate" value="<?php echo $todaydmy; ?>" id="listeddate" size="12" /></td></tr>
<tr><td class="fldview">Consultant</td><td class="data">
<?php
$selectname="consultant_id";
$optionid='uid';
$optionname="CONCAT (userlast,', ',userfirst) as consultant";
$optionwhere="WHERE consultantflag=1";
$orderby='userlast, userfirst';
$optiontable='renalware.userdata';
include( 'incl/makeselect.php' );
echo '</td></tr>
<tr><td class="fldview">Surgeon</td><td class="data">';
echo '<select name="surg_id">
    <option value="">Select...</option>';
$sql="SELECT surg_id, CONCAT(surglast, ', ', surgfirst) as surgeon FROM bedmgt.surgeons ORDER BY surglast, surgfirst";
$result = $mysqli->query($sql);
$numrows=$result->num_rows;
while($row = $result->fetch_assoc()) {
    echo '<option value="' . $row['surg_id'] . '">' . $row['surgeon'] . "</option>";
    }
echo "</select>";
echo '</td></tr>
<tr><td class="fldview">Priority</td><td class="data">
<input type="radio" name="priority" value="Routine" checked>Routine--6 wks plus &nbsp; &nbsp; <input type="radio" name="priority" value="Soon">Soon--within 4 weeks &nbsp; &nbsp; <input type="radio" name="priority" value="Urgent">URGENT--within 2 wks</td></tr>
<tr><td class="fldview">Procedure</td><td class="data">';
$selectname="procedtype_id";
$optionid='procedtype_id';
$optionname="CONCAT(proced, ' (', upper(category), ')')";
$orderby='category, proced';
$optiontable='procedtypes';
$optionwhere='';
include( 'incl/makeselect.php' );
?>
</td></tr>
<tr><td class="fldview">Management Intent</td><td class="data">
<input type="radio" name="mgtintent" value="Inpatient" checked="checked">Inpatient  &nbsp; &nbsp; <input type="radio" name="mgtintent" value="Renal Day Surgery">Renal Day Surgery
</td></tr>
<tr><td class="fldview">Surgery Date <br><i>(next <?php echo $limitdays ?> days with free slots shown)</i></td><td class="data">
<select name="surgdate">
<?php
if ($surgdate)
	{
	echo "<option value=\"$surgdate\">$surgdate_ddmy</option>";
	}
else
	{
	echo '<option value="">Select available date...</option>';
	}
$sql="SELECT diarydate, freeslots, DATE_FORMAT(diarydate, '%a %d/%m/%Y') AS diaryddmy, availslots from diarydates where freeslots>0 AND diarydate >=NOW() LIMIT $limitdays";
$result = $mysqli->query($sql);
while($row = mysqli_fetch_assoc($result))
	{
	echo '<option value="' . $row['diarydate'] . '">' . $row['diaryddmy'] . ' (' . $row["freeslots"] . ') ' . $row["availslots"] . '</option>';
	}
?>
</select>
<?php
//include 'showslotsform.php';
?>
</td></tr>
<tr><td class="fldview">Surgery Booked by</td><td class="data">
<select name="booker"><option value="<?php echo $user ?>"><?php echo $user ?></option>
<?php
$popcode="user";
$popname="authorsig";
$popwhere="bedmanagerflag=1";
$poptable="renalware.userdata";
include('incl/limitedoptions.php');
?>
</select>
</td></tr>
<tr><td class="fldview">TCI Date <br>(dd/mm/yyyy format) <br>(dd/mm is OK for current year)</td><td class="data">Date: <input type="text" name="tcidate" value="" id="tcidate" size="12">&nbsp;&nbsp;Time: <input type="text" name="tcitime" size="20" value="" id="tcitime"></td></tr>
<tr><td class="fldview">Pre-Op Assessment Date (if applic)</td><td class="data">Date: <input type="text" name="preopdate" value="" id="preopdate" size="12">
&nbsp;&nbsp;Time: <input type="text" name="preoptime" size="20" value="" id="preoptime"></td></tr>
<tr><td class="fldview">Infection Status</td><td class="data">
	MRSA status: <input type="radio" name="MRSA" value="unknown" checked>unknown &nbsp; &nbsp; <input type="radio" name="MRSA" value="neg">neg &nbsp; &nbsp; <input type="radio" name="MRSA" value="pos">pos <br>
	Other:<input type="checkbox" name="otherinfxnflag" value="yes" id="otherinfxnflag">Yes (specify): <input type="text" name="infxnother" value="" id="infxnother" size="20">
</td</tr>
<tr><td class="fldview">Special Needs/Options</td><td class="data">
Anaesthetic: <input type="radio" name="anaesth" value="LA">LA &nbsp; &nbsp; <input type="radio" name="anaesth" value="GA">GA
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="shortnotice" value="OK" id="shortnotice">Short Notice OK?
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="no_shortnotice" value="X" id="no_shortnotice">Not for Short Notice
</td</tr>
<tr><td class="fldview">Needs Transport?</td><td class="data">
<input type="radio" name="transportneed" value="N" checked>No &nbsp;&nbsp;&nbsp; &nbsp; <input type="radio" name="transportneed" value="Y">Yes
 &nbsp;&nbsp;If "Yes", <b>transport type</b>: <input type="text" name="transporttext" value="" id="transporttext" size=40>
</td</tr>
<tr><td class="fldview">Notes</td><td class="data"><textarea  class="form" name="schednotes" rows="7" cols="80"></textarea></td></tr>
</table>
<input type="submit" name="submit" value="Request Procedure for <?php echo $patient; ?>" id="submit" />
</fieldset>
</form>
</td>
<td valign="top">
<?php
include "patinfotable_incl.php";
include( 'incl/currmedsportal.php' );
?>
</td></tr>
</table>
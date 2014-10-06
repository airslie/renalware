<?php
//--Mon Mar  4 16:47:50 EST 2013--
$akidatamap=array(
    'aki_id'=>'x^aki_id',
    'akistamp'=>'x^created',
    'akimodifdt'=>'x^updated',
    'akiuid'=>'x^UID',
    'akiuser'=>'x^User',
    'akizid'=>'x^ZID',
    'akiadddate'=>'x^added',
    'akimodifdate'=>'x^modified',
    'episodedate'=>'c^episode date',
    'referraldate'=>'c^referral date',
    'admissionmethod'=>'s^admission method',
    'elderlyscore'=>'n^elderly?',
    //'existingckdscore'=>'n^existing CKD?',
    'ckdstatus'=>'s^CKD Status?',
    'cardiacfailurescore'=>'n^cardiac failure?',
    'diabetesscore'=>'n^diabetes?',
    'liverdiseasescore'=>'n^liver disease?',
    'vasculardiseasescore'=>'n^vascular disease?',
    'nephrotoxicmedscore'=>'n^nephrotoxic meds?',
    'akiriskscore'=>'x^AKI Risk Score',
    'cre_baseline'=>'t5^Baseline CRE',
    'cre_peak'=>'t5^Peak CRE',
    'egfr_baseline'=>'t5^baseline eGFR',
    'urineoutput'=>'s^urine output',
    'urineblood'=>'s^urine blood',
    'urineprotein'=>'s^urine protein',
    'akinstage'=>'x^AKIN Score',
    'stopdiagnosis'=>'s^STOP diagnosis',
    'stopsubtype'=>'s^STOP subtype',
    'stopsubtypenotes'=>'t100^STOP notes',
    'akicode'=>'x^AKI code',
    'ituflag'=>'f^ITU?',
    'itudate'=>'c^ITU date',
    'renalunitflag'=>'f^renal unit?',
    'renalunitdate'=>'c^renal unit date',
    'itustepdownflag'=>'f^ITU stepdown?',
    'rrtflag'=>'f^RRT in Renal Unit?',
    'rrttype'=>'s^RRT Type',
    'rrtduration'=>'s^RRT duration',
    'rrtnotes'=>'t50^RRT descr',
    'mgtnotes'=>'a6x70^Management Notes',
    'akioutcome'=>'s^Outcome',
    'ussflag'=>'f^USS?',
    'ussdate'=>'c^USS date',
    'ussnotes'=>'a6x70^USS results',
    'biopsyflag'=>'f^biopsy?',
    'biopsydate'=>'c^biopsy date',
    'biopsynotes'=>'a6x70^biopsy results',
    'otherix'=>'a6x70^other Investigations',
    'akinotes'=>'a6x70^AKI notes/comments',
	);

    $akiupdmap1=array(
        'aki_id'=>'x^aki_id',
        'akistamp'=>'x^created',
        'akimodifdt'=>'x^updated',
        'akiuid'=>'x^UID',
        'akiuser'=>'x^User',
        'akizid'=>'x^ZID',
        'akiadddate'=>'x^added',
        'akimodifdate'=>'x^modified',
        'episodedate'=>'c^episode date',
        'referraldate'=>'c^referral date',
        'admissionmethod'=>'s^admission method',
        'elderlyscore'=>'n^elderly?',
        //'existingckdscore'=>'n^existing CKD?',
        'ckdstatus'=>'s^CKD Status?',
        'cardiacfailurescore'=>'n^cardiac failure?',
        'diabetesscore'=>'n^diabetes?',
        'liverdiseasescore'=>'n^liver disease?',
        'vasculardiseasescore'=>'n^vascular disease?',
        'nephrotoxicmedscore'=>'n^nephrotoxic meds?',
        'akiriskscore'=>'x^AKI Risk Score',
        'cre_baseline'=>'t5^Baseline CRE',
        'cre_peak'=>'t5^Peak CRE',
        'egfr_baseline'=>'t5^baseline eGFR',
        'urineoutput'=>'s^urine output',
        'urineblood'=>'s^urine blood',
        'urineprotein'=>'s^urine protein',
        'akinstage'=>'x^AKIN Score',
        'akicode'=>'s^STOP diagnosis',
   );
    $akiupdmap2=array(
        'stopsubtypenotes'=>'t100^STOP notes',
        'ituflag'=>'f^ITU?',
        'itudate'=>'c^ITU date',
        'renalunitflag'=>'f^renal unit?',
        'renalunitdate'=>'c^renal unit date',
        'itustepdownflag'=>'f^ITU stepdown?',
        'rrtflag'=>'f^RRT in Renal Unit?',
        'rrttype'=>'s^RRT Type',
        'rrtduration'=>'s^RRT duration',
        'rrtnotes'=>'t50^RRT descr',
        'mgtnotes'=>'a6x70^Management Notes',
        'akioutcome'=>'s^Outcome',
        'ussflag'=>'f^USS?',
        'ussdate'=>'c^USS date',
        'ussnotes'=>'a6x70^USS results',
        'biopsyflag'=>'f^biopsy?',
        'biopsydate'=>'c^biopsy date',
        'biopsynotes'=>'a6x70^biopsy results',
        'otherix'=>'a6x70^other Investigations',
        'akinotes'=>'a6x70^AKI notes/comments',
    	);

$showakifields=array(
    // 'aki_id'=>'x^aki_id',
    // 'akistamp'=>'x^created',
    // 'akimodifdt'=>'x^updated',
    // 'akiuid'=>'x^UID',
    // 'akiuser'=>'x^User',
    'header1'=>'0^EPISODE INFO',
    'akiadddate'=>'x^added',
    'akimodifdate'=>'x^modified',
    'episodedate'=>'c^episode date',
    'admissionmethod'=>'s^admission method',
    'header2'=>'0^RISK STRATIFICATION',
    'elderlyscore'=>'n^elderly?',
//    'existingckdscore'=>'n^existing CKD?',
    'ckdstatus'=>'s^CKD Status',
    'cardiacfailurescore'=>'n^cardiac failure?',
    'diabetesscore'=>'n^diabetes?',
    'liverdiseasescore'=>'n^liver disease?',
    'vasculardiseasescore'=>'n^vascular disease?',
    'nephrotoxicmedscore'=>'n^nephrotoxic meds?',
    'akiriskscore'=>'x^AKI Risk Score',
    'header3'=>'0^AKI PARAMETERS',
    'referraldate'=>'c^referral date',
    'cre_baseline'=>'t5^Baseline CRE',
    'cre_peak'=>'t5^Peak CRE',
    'egfr_baseline'=>'t5^baseline eGFR',
    'urineoutput'=>'s^urine output',
    'urineblood'=>'s^urine blood',
    'urineprotein'=>'s^urine protein',
    'akinstage'=>'t4^AKIN Score',
    'header4'=>'0^AKI DIAGNOSIS',
    'stopdiagnosis'=>'s^STOP diagnosis',
    'stopsubtype'=>'s^STOP subtype',
    'stopsubtypenotes'=>'t100^STOP notes',
    'akicode'=>'x^AKI code',
    'header5'=>'0^EPISODE MANAGEMENT AND OUTCOME',
    'ituflag'=>'f^ITU?',
    'itudate'=>'c^ITU date',
    'renalunitflag'=>'f^renal unit?',
    'renalunitdate'=>'c^renal unit date',
    'itustepdownflag'=>'f^ITU stepdown?',
    'rrtflag'=>'f^RRT in Renal Unit?',
    'rrttype'=>'s^RRT Type',
    'rrtduration'=>'s^RRT duration',
    'rrtnotes'=>'t50^RRT descr',
    'mgtnotes'=>'a6x70^Management Notes',
    'akioutcome'=>'s^Outcome',
    'header6'=>'0^INVESTIGATIONS',
    'ussflag'=>'f^USS?',
    'ussdate'=>'c^USS date',
    'ussnotes'=>'a6x70^USS results',
    'biopsyflag'=>'f^biopsy?',
    'biopsydate'=>'c^biopsy date',
    'biopsynotes'=>'a6x70^biopsy results',
    'otherix'=>'a6x70^other Investigations',
    'akinotes'=>'a6x70^AKI notes/comments',
	);
			

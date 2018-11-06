select p.id as patient_id,
(select result from pathology_current_observations where description_code = 'HGB' and patient_id = p.id) as hgb_result,
(select observed_at from pathology_current_observations where description_code = 'HGB' and patient_id = p.id) as hgb_observed_at,
(select result from pathology_current_observations where description_code = 'CRE' and patient_id = p.id) as cre_result,
(select observed_at from pathology_current_observations where description_code = 'CRE' and patient_id = p.id) as cre_observed_at,
(select result from pathology_current_observations where description_code = 'URE' and patient_id = p.id) as ure_result,
(select observed_at from pathology_current_observations where description_code = 'URE' and patient_id = p.id) as ure_observed_at,
(select result from pathology_current_observations where description_code = 'MDRD' and patient_id = p.id) as mdrd_result,
(select observed_at from pathology_current_observations where description_code = 'MDRD' and patient_id = p.id) as mdrd_observed_at,
(select result from pathology_current_observations where description_code = 'HBA' and patient_id = p.id) as hba_result,
(select observed_at from pathology_current_observations where description_code = 'HBA' and patient_id = p.id) as hba_observed_at,
(select result from pathology_current_observations where description_code = 'FER' and patient_id = p.id) as fer_result,
(select observed_at from pathology_current_observations where description_code = 'FER' and patient_id = p.id) as fer_observed_at,
(select result from pathology_current_observations where description_code = 'PTHI' and patient_id = p.id) as pth_result,
(select observed_at from pathology_current_observations where description_code = 'PTHI' and patient_id = p.id) as pth_observed_at
from patients p

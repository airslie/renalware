# PET and Adequacy tests

There are test done on PD patients. They are not dependent on each other but are often
regarded as being connected, probably because they are often (but not always) done on the same day.

## PET

A PET (Peritoneal Equilibration Test) helps to establish the efficiency of the peritonoeum
during PD (pertioneal dialysis). If creatinine comes out quickly then patient can have shorter
dwells, otherwise longer dwells needed.

There are *full* and *fast* tests.

In a *full* PET the process is for example
- the PD patient visits clinic
- they are drained
- an (e.g.) 2.27% dextrose bag is attached
- during a 4 hour dwell period, dialysate samples are taken at 0, 2 and 4 hours
- the fluid is drained at 4hr (volume out)
- the dialysate samples  (including an overnight - usually 6hrs - sample) are sent for the
  following tests
  - Ur
  - Cr
  - glc
  - Na
  - protein
- bloods are taken (serum)

In a *fast* PET, patients may put in the 2.27% bag at home and come to clinic at the correct time
for a 4hr drain to be done, allowing `volume out` and the `4hr sample` concentration to be measured;
0h, 2h and overnight samples are not necessarily collected.

At Barts the fast test is more usual.


## Adequacy

This test is done at least every 6 months and  measures how much toxin is removed from the body
through the peritoneum via PD and through urine via the residual renal function. In theory toxins
through the peritoneum will not go up much, but toxin through urine will rise as renal function
worsens.

### Measurements

*Blood*

- SerumUrea
- SerumCreatinine
- PlasmaGlc
- SerumAb
- SerumNa

*Urine*

- Urine Urea
- Urine Creatinine
- Urine Na
- Urine K
- Urine Protein

*Dialysate*

- Dialysate Urea
- Dialysate Creatinine
- Dialysate glc
- Dialysate Na
- Dialysate Protein

### Calculations

These predefined pre-calculated values will have been stored against a clinic visit
when it is saved:

* BSA = Body Surface Area (using DuBois)
  * `0.007184*Weight^0.425*(Height)^0.725`
* TBW = Total Body Water (using Watson)
  * Male `2.447 - (0.09156*Age) + (0.1074*Height) + (0.3362*Weight)`
  * Female `-2.097 + (0.1069*Height) + (0.2466*Weight))`

#### Dietry Protein Intake (DPI)

Using Bergstrom I

```
Round((19+0.272*((Dial24_Urea*Dial24_VolOut/1000) + (Urine24_Urea*Urine24_Vol/1000)))/Weight,2))
```

#### Creatinine Clearances

```
Total Creatinine Clearance = Residual Renal Function (RRF) + Peritoneal Creatinine Clearance (PeritonealCrCl)

PeritonealCrCl = Round( (Dial24_Creat*Dial24_VolOut/1000) / SerumCreatinine *7 *1.72/ BSA,0)

RRF = Round((RenalCrCl_calculated + RenalUrCl_calculated)/(2*BSA)*1.72,0)

RenalCrCl_calculated = (Urine24_Creat *Urine24_Vol)/SerumCreatinine*7
RenalUrCl_calculated =  (Urine24_Urea*Urine24_Vol/1000)/SerumUrea*7
```

## UI Workflow

Both tests happen in phases
- collect patient samples
- enter pathology (manually or automatically) when it returns from the lab
- store calculated data

### Refreshing pathology

#### PET

After a PET, serum (blood) and dialysis samples are sent to the lab. When they come back
the user needs to edit the PET and enter the values. We try to make this a bit easier by
finding the serum test results when the user click 'Refresh', and inserting them into the
table along with some metadata to idenfity the OBX code and test time, so a user can check these
are the correct results.

### When is a test finished?

#### PET

If there is (calculated) D/Pcr showing in table, then the test is finished.

#### Adequacy

If there is a Total kt/v, then clearly the test is finished as both the Peritoneal
and the Residual Renal Function component has been calculated.

*If patient brought up Peritoneal Part of Adequacy but not the 24hr Urine*

or

*If patient brought up the 24hr Urine but not the Peritoneal Part of Adequacy*

Then once kt/v_Perit null, then the test is finished (kt/v_RRF and no kt/v_T will be null).

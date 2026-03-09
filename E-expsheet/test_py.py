import re

data = """<p class="Normal tm5"><strong><span class="tm7">II. QUAN HỆ GIA ĐÌNH (</span><em><span class="tm8">RELATIVES)</span></em></strong></p>

<p class="Normal tm9"><strong><span class="tm7">1. Họ và tên cha (Father’s full name): NGUYEN VAN A</span></strong></p>

<p class="Normal tm9"><span class="tm10">- Năm sinh (Year of birth):1960</span></p>

<p class="Normal tm11"><span class="tm10">- Nghề nghiệp hiện nay (Occupation): retirement</span></p>

<p class="Normal tm11"><span class="tm10">- Cơ quan công tác(Company’s name): home</span></p>

<p class="Normal tm11"><span class="tm10">- Chỗ ở hiện nay (Current address): 550/10/2 To Ky Street, Trung My Tay Ward, Ho Chi Minh City</span></p>

<p class="Normal tm9"><strong><span class="tm7">2. Họ và tên mẹ (Mother’s full name): NGUYEN THI B</span></strong></p>

<p class="Normal tm9"><span class="tm10">- Năm sinh (Year of birth):&#160;1961</span></p>

<p class="Normal tm11"><span class="tm10">- Nghề nghiệp hiện nay (Occupation): home work</span></p>

<p class="Normal tm11"><span class="tm10">- Cơ quan công tác (Company’s name): home</span></p>

<p class="Normal tm11"><span class="tm10">- Chỗ ở hiện nay (Current address): 550/10/2 To Ky Street, Trung My Tay Ward, Ho Chi Minh City</span></p>

<p class="Normal tm5"><strong><span class="tm7">3. Họ và tên Anh/ chị em ruột (Sibling’s full name):NGUYEN VAN C</span></strong></p>

<p class="Normal tm8"><span class="tm6">- Năm sinh (Year of birth):&#160;1990</span></p>

<p class="Normal tm8"><span class="tm6">- Nghề nghiệp hiện nay (Occupation):&#160;worker</span></p>

<p class="Normal tm8"><span class="tm6">- Cơ quan công tác (Company’s name):&#160;vietjetair</span></p>

<p class="Normal tm5"><strong><span class="tm7">4. Họ và tên Anh/ chị em ruột (Sibling’s full name): NGUYEN THI D</span></strong></p>

<p class="Normal tm8"><span class="tm6">- Năm sinh (Year of birth):&#160;1999</span></p>

<p class="Normal tm8"><span class="tm6">- Nghề nghiệp hiện nay (Occupation):&#160;teacher</span></p>

<p class="Normal tm8"><span class="tm6">- Cơ quan công tác (Company’s name): VJAA</span></p>"""

def split_extract(text, delimiter, occurrence):
    parts = text.split(delimiter)
    if len(parts) > occurrence:
        part = parts[occurrence]
        val = part.split('<')[0]
        # remove any html entities like &#160;
        val = val.replace('&#160;', '').strip()
        return val
    return None

def extract_pos(clean_text, start_pattern, occ):
    pass

father_name = split_extract(data, "Father’s full name):", 1)
father_yob = split_extract(data, "Year of birth):", 1)
father_occ = split_extract(data, "Occupation):", 1)
father_comp = split_extract(data, "Company’s name):", 1)
father_addr = split_extract(data, "Current address):", 1)

mother_name = split_extract(data, "Mother’s full name):", 1)
mother_yob = split_extract(data, "Year of birth):", 2)
mother_occ = split_extract(data, "Occupation):", 2)
mother_comp = split_extract(data, "Company’s name):", 2)
mother_addr = split_extract(data, "Current address):", 2)

sib1_name = split_extract(data, "Sibling’s full name):", 1)
sib1_yob = split_extract(data, "Year of birth):", 3)
sib1_occ = split_extract(data, "Occupation):", 3)
sib1_comp = split_extract(data, "Company’s name):", 3)

sib2_name = split_extract(data, "Sibling’s full name):", 2)
sib2_yob = split_extract(data, "Year of birth):", 4)
sib2_occ = split_extract(data, "Occupation):", 4)
sib2_comp = split_extract(data, "Company’s name):", 4)

print("Father:", father_name, father_yob, father_occ, father_comp, father_addr)
print("Mother:", mother_name, mother_yob, mother_occ, mother_comp, mother_addr)
print("Sib1:", sib1_name, sib1_yob, sib1_occ, sib1_comp)
print("Sib2:", sib2_name, sib2_yob, sib2_occ, sib2_comp)

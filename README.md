With no wait states, and no PSLVERR support.

Port descriptions [1]: <br>
<img width="653" height="469" alt="Screenshot (594)" src="https://github.com/user-attachments/assets/c090dbbb-c65a-41d8-8217-d49a152c37f5" />

State diagram [1]: <br>
<img width="356" height="311" alt="Screenshot (595)" src="https://github.com/user-attachments/assets/3884ea99-5408-450d-ae07-008c176c3936" />

Register Map: 
<br>0x00: 32-bit R/W register. 
<br>0x04: 32-bit R/W register. 
<br>0x08: 32-bit R/W register. 
<br>0x0C: 32-bit R/W register.

Register Indexing:
<br>localparam INDEX_LSB = $clog2(DATA_WIDTH/8);
<br>localparam INDEX_MSB = ($clog2(REG_NUM) + INDEX_LSB - 1);
<br> With DATA_WIDTH = 32 and REG_NUM = 4, the MSB = 3 and LSB = 2. For PADDR from 0x00 to 0x03, PADDR[3:2] = 0, and so on.

Simulation Waveform: <br>
<img width="837" height="337" alt="Screenshot (593)a" src="https://github.com/user-attachments/assets/a6406653-26d2-40ea-ac72-82999a3b9239" />

EDA Playground:
<br>https://edaplayground.com/x/TWUV

Reference: <br>
[1] AMBA 3 APB Protocol Specification, Issue B (2004)

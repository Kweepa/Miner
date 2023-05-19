@echo off
\app\acme\acme -o miner.a0 --vicelabels miner.lbl miner.asm
call \app\WinVice-3.1-x64\xvic -pal -cartgeneric miner.A0

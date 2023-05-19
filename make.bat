@echo off
\app\acme\acme -o miner.prg --vicelabels miner.lbl miner.asm
AcmeLabelSorter miner.lbl miners.lbl
call \app\WinVice-3.1-x64\xvic -pal miner.prg

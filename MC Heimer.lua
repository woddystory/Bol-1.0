
--[[

    Beta MC Heimer v0.28
    
    v0.26 -  release
    
    v0.28 - Improved Combo Logic
          - Added Harass Button
          - Little finetune on the dodge Logic
          - Fixed bug with cast spells
          - Option on the Menu to enable or disable minion collision on W (enable as default)
 
--]]




assert(load(Base64Decode("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BAIAAABFAAQHAAAARWNvbWJvAAQIAAAARWhhcmFzcwAEBgAAAEVoaXRjAAQMAAAAUiAtIFVwZ3JhZGUABAIAAABSAAQHAAAAUmNvbWJvAAQIAAAAUmhhcmFzcwAEDwAAAEF1dG8tSW50ZXJydXB0AAQOAAAAQXV0b0ludGVycnVwdAAEBgAAAGF1dG9FAAQRAAAAQXV0byBHcmFuYWRlIChFKQAEBQAAAGluZm8ABAIAAAAgAAQSAAAAU0NSSVBUX1BBUkFNX0lORk8ABAMAAAAgIAAEDAAAAGhlcm9NYW5hZ2VyAAQHAAAAaUNvdW50AAQIAAAAZ2V0SGVybwAEBQAAAHRlYW0ABAcAAABwbGF5ZXIABAoAAABDaGFtcGlvbnMABAkAAABjaGFyTmFtZQAABAYAAABwYWlycwAECwAAAHNraWxsc2hvdHMABAoAAABpbnRlcnJ1cHQAAQEECgAAAHNwZWxsTmFtZQAEBAAAACAtIAAEBgAAAEV2YWRlAAQGAAAAZG9kZ2UABAYAAABhdXRvUQAEEAAAAEF1dG8gVHVycmV0IChRKQAECgAAAGJsb2NrYWJsZQAEDgAAAE1pc2NlbGFubmVvdXMABAUAAABNaXNjAAQFAAAAc2tpbgAEFAAAAFNraW5IYXggYnkgU2hhbHp1dGgAAwAAAAAAABhABA4AAABBbGllbiBJbnZhZGVyAAQLAAAAQmxhc3QgWm9uZQAEEQAAAFBpbHRvdmVyIEN1c3RvbXMABA4AAABTbm93bWVyZGluZ2VyAAQHAAAASGF6bWF0AAQNAAAAQ2xhc3NpYyBTa2luAAQJAAAARHJhd2luZ3MABAUAAABkcmF3AAQNAAAAQ3JlYXRlQ2lyY2xlAAQHAAAAbXlIZXJvAAMAAAAAAOBvQAQKAAAAQWRkVG9NZW51AAQIAAAAUSByYW5nZQAECAAAAFcgcmFuZ2UABAgAAABFIHJhbmdlAAQFAAAAbW9kZQAEDAAAAFByZWRpY3Rpb25zAAQLAAAAUHJvZGljdGlvbgAEBgAAAGNvbWJvAAQMAAAAU21hcnQgQ29tYm8ABBcAAABTQ1JJUFRfUEFSQU1fT05LRVlET1dOAAMAAAAAAABAQAQHAAAAaGFyYXNzAAQHAAAASGFyYXNzAAMAAAAAAMBQQAQGAAAAcHJpbnQABE0AAAA8Yj48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BAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAA7AAAABwAAAEEAAAA8AAAASQAAAEIAAABfAAAASgAAAGcAAABgAAAAaAAAAGgAAABxAAAAaQAAAHoAAAByAAAAiwAAAHsAAACeAAAAjAAAAKMAAACfAAAApAAAAKQAAAClAAAApAAAAKoAAACmAAAAsAAAAKsAAACwAAAAEwAAAAMAAABfZAAQAAAA9AEAAAMAAABhZADHAQAA9AEAAAMAAABiZADHAQAA9AEAAAMAAABjZADHAQAA9AEAAAMAAABkZADHAQAA9AEAAAQAAABfX2EAywEAAPQBAAAEAAAAYV9hAMsBAAD0AQAABAAAAGJfYQDLAQAA9AEAAAQAAABjX2EAywEAAPQBAAAEAAAAZF9hAM8BAAD0AQAABAAAAF9hYQDPAQAA9AEAAAQAAABhYWEAzwEAAPQBAAAEAAAAYmFhAM8BAAD0AQAABAAAAGNhYQDQAQAA9AEAAAQAAABkYWEA0QEAAPQBAAAEAAAAX2JhANIBAAD0AQAABAAAAGFiYQDTAQAA9AEAAAQAAABiYmEA1AEAAPQBAAAEAAAAY2JhANUBAAD0AQAAAQAAAAUAAABfRU5WAA=="), nil, "bt", _ENV))()
-- Easy Copy Paste

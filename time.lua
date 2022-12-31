-- constants

SECONDS_IN_DAY = 86400
UNIXEPOCH_TO_MJD = 40586.5

-- time & date

function tzoffset()
    local now = os.time() + 3600
    local t = os.date("*t", now)
    return (86400 + t['hour']*3600 + t['min']*60 + t['sec'] - now) % 86400
end

function normalize_to_localtime_midnight(sec_since_epoch)
	return sec_since_epoch - (sec_since_epoch + tzoffset()) % SECONDS_IN_DAY
	-- return sec_since_epoch - sec_since_epoch % SECONDS_IN_DAY - tzoffset()
end

function now_epoch()  -- to be mocked for debugging
	return os.time()
end

function intdate_to_epoch(intdate)  -- e.g., 20221028
	return os.time{
			year = math.floor(intdate / 10000),
			month = math.floor(intdate % 10000 / 100),
			day = intdate % 100,
		}
end

function epoch_to_mjd(epoch)  -- modified julian day
	return (epoch + tzoffset()) / SECONDS_IN_DAY + UNIXEPOCH_TO_MJD
end

function mjd_to_epoch(mjd)  -- modified julian day
	return (mjd - UNIXEPOCH_TO_MJD) * SECONDS_IN_DAY - tzoffset()
end

function intdate_to_mjd(intdate)
	return epoch_to_mjd(intdate_to_epoch(intdate))
end

function weekday_of_mjd(mjd)
	-- return os.date('%w', mjd_to_epoch(mjd))
	return (mjd + 3) % 7
end

function now_mjd()
	return epoch_to_mjd(now_epoch())
end


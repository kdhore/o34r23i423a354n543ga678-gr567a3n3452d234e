function [] = submit(fname)
	% check we're connected to the server
	if (exist('/Volumes/oriangagrande','dir') == 0)
		error('Not connected to oriangagrande server, connect and run submit(subname) to submit.');
	end

	% submit our file the server
	fpath = strcat('decisions\ \(Excel\)/',fname); % fuck whoever named this directory
	subpath = strcat('/Volumes/oriangagrande/',fname);
	unixstr = strcat('cp', {' '}, fpath, {' '}, subpath);
	unix(unixstr{1});

	% make sure the file submitted
	if (exist(subpath,'file') == 2)
		sucStr = strcat('successfully submitted', {' '}, fname);
		disp(sucStr{1});
	else
		errStr = 'File not submitted, something went wrong';
		disp(errStr);
	end
end
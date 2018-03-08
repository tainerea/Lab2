
%% Open Serial Port
s = serial('COM3', 'BaudRate',19200,'Terminator', 10, 'Timeout', 5); %configure serial port
fopen(s); % Open Serial Port
fprintf(s,'INITIALIZE'); % Send Intialize Command 
instrfind('Type', 'serial','status', 'open') % can find serial ports with status of open

%% Menu
while 1
chosen_cmd = menu('Choose command','Reset','X-Axis','Z-Axis', 'Gripper', 'Move', 'Status', 'Specical Moves', 'Exit');
switch chosen_cmd
    case 1 %Reset
        fprintf(s, 'RESET');
    case 2 %X-Axis
        move_x = menu('Choose a location to move to', '1', '2','3', '4', '5');
        x_cmd = sprintf('X-AXIS %d\n', move_x);
        fprintf(s,x_cmd);
    case 3 %Z-Axis
        move_z = menu('Z-Axis','EXTEND','RETRACT');
        switch move_z
            case 1 
                fprintf(s, 'Z-AXIS EXTEND');
            case 2
                fprintf(s, 'Z-AXIS RETRACT');
        end
    case 4 %Gripper
        gripper_pos = menu('Use Gripper','Open','Close')
        switch gripper_pos 
            case 1 
                fprintf(s, 'GRIPPER OPEN');
            case 2
                fprintf(s, 'GRIPPER CLOSE');
        end
    case 5 %Move
        plate_loc = inputdlg({'Input Plate Pickup Location', 'Input Plate Dropoff Location'},'Move',[1 50; 1 50]);
        pickup = plate_loc{1};
        dropoff = plate_loc{2};
        move_maker = sprintf('MOVE %d %d\n', pickup-48, dropoff-48);
        fprintf('%s', move_maker)
        fprintf(s, move_maker);
    case 6 %Status
        fprintf(s, 'LOADER_STATUS');
        status_load = fscanf(s);
        uiwait(helpdlg(status_load)); % display status 
    case 7 %Special Moves
        moveslikejagger = menu('Special Moves','LeapFrog')
        switch moveslikejagger
            case 1 
                uiwait(helpdlg('Please place plates at locations 4 and 5'));
                for i = 5 : -1 : 3
                    %Pick up Plate
                    str = sprintf('X-AXIS %d', i);
                    fprintf(str)
                    fprintf(s, str);
                    fscanf(s); % wait for response
                    fprintf(s, 'GRIPPER OPEN');
                    fscanf(s);
                    fprintf(s, 'Z-AXIS EXTEND');
                    fscanf(s);
                    fprintf(s, 'GRIPPER CLOSE');
                    fscanf(s);
                    fprintf(s, 'Z-AXIS RETRACT');
                    fscanf(s);
                    % Move Plate Over (Leap) 
                    str = sprintf('X-AXIS %d', i-2);
                    fprintf(str)
                    fprintf(s, str);
                    fscanf(s);
                    fprintf(s, 'Z-AXIS EXTEND');
                    fscanf(s);
                    fprintf(s, 'GRIPPER OPEN');
                    fscanf(s);
                    fprintf(s, 'Z-AXIS RETRACT');
                    fscanf(s);
                    fprintf(s, 'GRIPPER CLOSE');
                    fscanf(s);
                end
                
            case 2
                % does nothing right now
        end
    case 8 %Exit
        fclose(s);
        close all;
        break
        end
end
fclose(s);
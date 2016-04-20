%% Organize standard ERG trial data
% From matrix with all values --> structure
% Import time and peaks (optional) seperately

function S = importBipolar(S,gt,bkgd)
  %% genotype and background as strings - 'crx','dark'
  % S, and data usually already on S from other import function
if strcmpi(gt,'crx') == 1
    genotype = 'crx:trB2';
else
    genotype = 'wildtype';
end

ct = 0;
wl_list = [651 570 490 410 330 652 610 530 450 370];
ndf_list = [50 45 40 35 30 25 20 15 10 05 00];
for ii = 1:10
  if ii == 1
    wl = 'nm650A';
  elseif ii == 2
    wl = 'nm650B';
  else
    wl = sprintf('nm%u', wl_list(ii));
  end
  S.(gt).(bkgd).(wl) = [];
  for jj = 1:7
    row = jj + (ct*7);
    if strcmpi(wl, 'nm650A') == 1
      nd = ndf_list(jj+2);
    elseif strcmpi(wl,'nm650B') == 1
      nd = ndf_list(jj+1);
    else
      nd = ndf_list(jj);
    end
    nd = sprintf('nd%u',nd);
   % S.(gt).(bkgd).(wl).nd = sprintf('%.1fnd',nd);
    S.(gt).(bkgd).(wl).(nd).erg = S.(gt).(bkgd).all(:,ii);
  end
  ct = ct + 1;
end

%% PLOT
 wl_list = [651 570 490 410 330 652 610 530 450 370];
wl_order = [5 10 4 9 5 8 2 7 6 1];
% c = zeros(10,3);
 c = [saraColors.purple(:) saraColors.parma(:) saraColors.dblue(:) saraColors.medblue(:) saraColors.teal(:) saraColors.green(:) saraColors.yellow(:) saraColors.yelloworange(:) saraColors.red(:) saraColors.red(:)];

figure('windowstyle','docked');
for ii = 1:10
    p = wl_order(ii) * 7;
    plot(S.ergtime,S.(gt).(bkgd).all(:,p),'linewidth',1,'tag',sprintf('%unm',wl_list(wl_order(ii))),'color',c(:,ii));
    hold on;
end
legend('330nm','370nm','410nm','450nm','490nm','530nm','570nm','610nm','650Anm','650Bnm','location','eastoutside');
title(sprintf('%s PII ERG (%s bkgd)',genotype,bkgd));
xlabel('time (ms)');
ylabel('amplitude (uV)');

%% plot peaks
figure('windowstyle','docked');
S.(gt).(bkgd).peaks = zeros(10,2);
%    row = jj + (ct*7);
for ii = 1:10
    p = wl_order(ii) * 7;
    if wl_order(ii) == 8
      nd = 'nd1.5';
    elseif wl_order(ii) == 9
      nd = 'nd1.0';
    else
      nd = 'nd2.0';
    end
    [a, b] = max(S.(gt).(bkgd).all(:,p));
    wl = sprintf('nm%u',wl_list(wl_order(ii)));
    plot(b,a,'o','markeredgecolor',c(:,ii),'markerfacecolor',c(:,ii)); hold on;
    S.(gt).(bkgd).peaks(ii,:) = [y i];
 %   S.(gt).(bkgd).(wl).(nd).peak = [y i];
end
legend('330nm','370nm','410nm','450nm','490nm','530nm','570nm','610nm','650Anm','650Bnm','location','eastoutside');
title(sprintf('%s PII ERG (%s bkgd)',genotype,bkgd));
xlabel('time (ms)');
ylabel('amplitude (uV)');

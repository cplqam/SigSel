function [resultado] = torical_experimental_masses_comparation_ROIMCR(file,mz_teo,ppm_permitido, ionization)
%This function compares the m/z value of a chemical compound with the 
% MSROI values of the MCR components spectra resulting from
%'mz_components_new.m'

%INPUT
%file: resultads from 'mz_components_new.m'
%ppm_permitido: maximum ppm error value considered between theorical
%and experimental value
%mz_teo: monoisotopic m/z value suspected 
%inonization: positive(0) o negative(1)

%OUTPUT
%resultado: cell variable with the matched signals between MCR results and 
% theorical m/z:
    %Columna 1: number of component
    %Columna 2: cell matrix
        %col 1: experimental m/z
        %col 2: theorical m/z
        %col 3: monoisotopic/aduct found
        %col 4: ppm of the match

n_comp = size(file,1);
resultado = {};
cont = 1;

if ionization == 0;
    in = input('Do you consider any other aduct apart from monoisotopic ion? yes(0)/no(1)');

    if in == 0
        aductos = input('Introduce the masses of these aducts as string array of 1 row (e.g Na = 22.9897 or NH4 = 18.0338): ');
        if size(aductos,1) > 1
            error('You must introduce de masses of the aducts as string array of 1 row');
        end
        aductos = [1.0073,aductos];
        mz_teo = mz_teo-1.0073;
        for n = 1:n_comp
            comp = file(n,:);
            mz = [comp.mz_values];
            n_mz = size(mz,2);
            res = [];
            for i = 1:n_mz
                mz_exp = mz(i);
                for mass_aducto = aductos
                    mz_teo_aduct = mass_aducto+mz_teo;
                    if mz_exp > mz_teo_aduct
                        ppm = (1-(mz_teo_aduct/mz_exp))*1000000;
                    elseif mz_teo_aduct >= mz_exp
                        ppm = (1-(mz_exp/mz_teo_aduct))*1000000;
                    end
                    if ppm_permitido >= ppm
                        res = [res;mz_exp,mz_teo,mz_teo_aduct,ppm];
                    end
                end
            end
            ts = isempty(res);
            if ts == 0
                resultado{cont,1} = strcat('Component ',{' '}, num2str(comp.Components));
                resultado{cont,2} = res;
                cont = cont+1;
            end
        end
    elseif in == 1
        for n = 1:n_comp
            comp = file(n,:);
            mz = [comp.mz_values];
            n_mz = size(mz,2);
            res = [];
            for i = 1:n_mz
                mz_exp = mz(i);
                if mz_exp > mz_teo
                    ppm = (1-(mz_teo/mz_exp))*1000000;
                elseif mz_teo >= mz_exp
                    ppm = (1-(mz_exp/mz_teo))*1000000;
                end
                if ppm_permitido >= ppm
                    res = [res;mz_exp,mz_teo-1.0073,mz_teo,ppm];
                end
            end
            ts = isempty(res);
            if ts == 0
                resultado{cont,1} = strcat('Component ',{' '}, num2str(comp.Components));
                resultado{cont,2} = res;
                cont = cont+1;
            end
        end
    end
elseif ionization == 1
    in = input('Do you consider any other aduct apart from deprotonated ion? yes(0)/no(1)')

    if in == 0
        aductos = input('Introduce the masses of these aducts as string array of 1 row (e.g -H2O-H- = 19.0226, +Na-2H- = 20.9751): ');
        if size(aductos,1) > 1
            error('You must introduce de masses of the aducts as string array of 1 row');
        end
        aductos = [1.0073,aductos];
        mz_teo = mz_teo+1.0073;
        for n = 1:n_comp
            comp = file(n,:);
            mz = [comp.mz_values];
            n_mz = size(mz,2);
            res = [];
            for i = 1:n_mz
                mz_exp = mz(i);
                for mass_aducto = aductos
                    mz_teo_aduct = mz_teo-mass_aducto;
                    if mz_exp > mz_teo_aduct
                        ppm = (1-(mz_teo_aduct/mz_exp))*1000000;
                    elseif mz_teo_aduct >= mz_exp
                        ppm = (1-(mz_exp/mz_teo_aduct))*1000000;
                    end
                    if ppm_permitido >= ppm
                        res = [res;mz_exp,mz_teo,mz_teo_aduct,ppm];
                    end
                end
            end
            ts = isempty(res);
            if ts == 0
                resultado{cont,1} = strcat('Component ',{' '}, num2str(comp.Components));
                resultado{cont,2} = res;
                cont = cont+1;
            end
        end
    elseif in == 1
        for n = 1:n_comp
            comp = file(n,:);
            mz = [comp.mz_values];
            n_mz = size(mz,2);
            res = [];
            for i = 1:n_mz
                mz_exp = mz(i);
                if mz_exp > mz_teo
                    ppm = (1-(mz_teo/mz_exp))*1000000;
                elseif mz_teo >= mz_exp
                    ppm = (1-(mz_exp/mz_teo))*1000000;
                end
                if ppm_permitido >= ppm
                    res = [res;mz_exp,mz_teo+1.0073,mz_teo,ppm];
                end
            end
            ts = isempty(res);
            if ts == 0
                resultado{cont,1} = strcat('Component ',{' '}, num2str(comp.Components));
                resultado{cont,2} = res;
                cont = cont+1;
            end
        end
    end    
end


classdef person
   properties %(here, properties is a keyword)
       mass=80;
       height=1.80;
   end
   methods
       function BMI = getBMI(height,weight)
           BMI = person.mass/person.mass^2;
       end
   end
end

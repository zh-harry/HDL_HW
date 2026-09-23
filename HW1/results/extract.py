import re
import csv

data_table = {}

UNIT_MULTIPLIER = {
    'm': 1e-3,  
    'u': 1e-6,  
    'n': 1e-9,  
    'p': 1e-12, 
    '': 1.0     
}

def calculate_power(match_object):
    if match_object:
        value = float(match_object.group(1))
        unit = match_object.group(2)
        if unit in UNIT_MULTIPLIER:
            return value * UNIT_MULTIPLIER[unit]
    return -1.0

def read_results(module, optimized):
    module_type = module + '_' + optimized
    data_table.setdefault(module_type, {})

    file_path = "/MasterClass/StudentID_HDL/HW1/gate_level/{0}/{1}/1.timing_report_{0}.txt".format(module, optimized)

    with open(file_path, "r") as file:
        content = file.read()
        match = re.search(r"max_delay\s*([\d.]+)", content)
        match_reg = re.findall(r"clock clk \(rise edge\)\s*([\d.]+)", content)

        if match:
            data_table[module_type]["Delay"] = float(match.group(1))
        elif len(match_reg) >= 2:
            data_table[module_type]["Delay"] = float(match_reg[1])
        elif len(match_reg) >= 1:
            data_table[module_type]["Delay"] = float(match_reg[0])
        else:
            data_table[module_type]["Delay"] = -1.0

    file_path = "/MasterClass/StudentID_HDL/HW1/gate_level/{0}/{1}/2.area_report_{0}.txt".format(module, optimized)

    with open(file_path, "r") as file:
        content = file.read()
        match_CL = re.search(r"Combinational area:\s*([\d.]+)", content)
        match_SL = re.search(r"Noncombinational area:\s*([\d.]+)", content)
        match_total = re.search(r"Total cell area:\s*([\d.]+)", content)

        data_table[module_type]["CL"] = float(match_CL.group(1)) if match_CL else -1.0
        data_table[module_type]["SL"] = float(match_SL.group(1)) if match_SL else -1.0
        data_table[module_type]["Area_Total"] = float(match_total.group(1)) if match_total else -1.0

    file_path = "/MasterClass/StudentID_HDL/HW1/gate_level/{0}/{1}/3.power_report_{0}.txt".format(module, optimized)

    with open(file_path, "r") as file:
        content = file.read()
        match_dynamic = re.search(r"Total Dynamic Power\s*=\s*([\d.]+)\s*([a-zA-Z]?)W", content)
        match_leakage = re.search(r"Cell Leakage Power\s*=\s*([\d.]+)\s*([a-zA-Z]?)W", content)

        dynamic = calculate_power(match_dynamic)
        leakage = calculate_power(match_leakage)
        total = dynamic + leakage
        data_table[module_type]["Dynamic"] = "{:e}".format(dynamic)
        data_table[module_type]["Leakage"] = "{:e}".format(leakage)
        data_table[module_type]["Power_Total"] = "{:e}".format(total) if dynamic >= 0 and leakage >= 0 else -1.0

if __name__ == "__main__":
    module_list = ["adder_structure", "adder_structure_reg", 
                   "adder_dataflow",  "adder_dataflow_reg" ,
                   "adder_behavior",  "adder_behavior_reg" ]
    
    optimized_list = ["Delay", "Area", "Between"]

    columns = ["CL", "SL", "Area_Total", "Delay", "Dynamic", "Leakage", "Power_Total"]
    
    # begin to fetch data
    for module in module_list:
        for optimized in optimized_list:
            read_results(module, optimized)

    # output to txt file
    with open("results.txt", "w") as txt_file:
        header = "  {:<22}".format("Module Name")
        header += "{:<15}".format("Optimized")
        for col in columns:
            header += "{:<15}".format(col)

        txt_file.write(header + "\n")
        txt_file.write("+" + "-" * 21 + "+" + "-" * 123 + "+\n")

        for module in module_list:
            cnt = 1
            for optimized in optimized_list:
                module_type = module + '_' + optimized

                if module_type in data_table:
                    row = "| "
                    row += " " * 20 if cnt != 2 else "{:<20}".format(module)
                    row += "| {:<15}".format(optimized)
                    cnt += 1
                    
                    for col in columns:
                        value = data_table[module_type].get(col, "N/A")
                        row += "{:<15}".format(value)
                        
                    txt_file.write(row + "  |\n")   
                else:
                    txt_file.write("{:<25}Data Missing!\n".format(module))
                    
            txt_file.write("+" + "-" * 21 + "+" + "-" * 123 + "+\n")

    # output to csv file
    with open("results.csv", "wb") as csv_file:
        writer = csv.writer(csv_file)

        header = ["Module", "Optimized"] + columns
        writer.writerow(header)

        for module in module_list:
            for optimized in optimized_list:
                module_type = module + '_' + optimized

                if module_type in data_table:
                    row = [module, optimized]
                    for col in columns:
                        row.append(data_table[module_type].get(col, "N/A"))
                    writer.writerow(row)
                else:
                    writer.writerow([module, optimized, "Data Missing!"])

    print("Results saved sucessfully!")
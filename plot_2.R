rm(list = ls())
cat("\014")

st <- Sys.time()

require(data.table)
require(ggplot2)
require(rqdatatable)

df <- fread("data/household_power_consumption.txt", na.strings="?", nrows = 1)
optree <- local_td(df) %.>%
    # Filter Dates for 2007-02-01 and 2007-02-02
    select_rows_nse(., Date == "1/2/2007" | Date == "2/2/2007")

df <- fread("data/household_power_consumption.txt", na.strings="?") %.>% optree
df[,dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]


plot_2 <- ggplot(df, aes(dateTime, Global_active_power)) +
    geom_line(colour = "black") +
    scale_x_datetime(date_breaks = "1 day", date_labels = "%a") + 
    scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
    labs(y = "Global Active Power (kW)") +
    theme_light() +
    theme(text = element_text(face = "bold"))

print(plot_2)
ggsave(plot_2, filename = "codes/ExData_Plotting1/plot_2.png", width = 4, height = 4, dpi = 120)

et <- Sys.time()
print(et-st)

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
df[,Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]

plot_1 <- ggplot(df, aes(Global_active_power)) +
    geom_histogram(fill = "dodgerblue3", colour = "black", bins = 18) +
    scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
    scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
    labs(x = "Global Active Power (kW)", y = "Frequency") +
    ggtitle("Global Active Power") +
    theme_light() +
    theme(text = element_text(face = "bold"),
          plot.title = element_text(hjust = 0.5))

print(plot_1)
ggsave(plot_1, filename = "codes/ExData_Plotting1/plot_1.png", width = 4, height = 4, dpi = 120)

et <- Sys.time()
print(et-st)
